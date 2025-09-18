//
//  InternshipViewModel.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import Foundation
import Combine

final class InternshipViewModel: ObservableObject {
    // Input
    @Published var searchText: String = ""
    @Published var selectedSkillIds: Set<UUID> = []
    @Published var selectedLocationIds: Set<UUID> = []
    @Published private var isRecommendedMode: Bool = false

    // Output
    @Published private(set) var internships: [Internship] = []
    @Published private(set) var filtered: [Internship] = []
    @Published private(set) var allSkills: [Skill] = []
    @Published private(set) var allLocations: [Location] = []
    @Published private(set) var savedInternships: [Internship] = []
    
    private let userRepository = UserRepository()

    private var cancellables: Set<AnyCancellable> = []
    private let topRecommendationLimit: Int = 5
    private let qualificationOrder: [Qualification: Int] = [.twelfth: 0, .bachelors: 1, .masters: 2]
    
    // MARK: - Config
    struct RecommendationConfig {
        // Classic rule-based weights
        var weightSkillExact: Int = 3
        var weightSkillRelated: Int = 1
        var weightSector: Int = 5
        var weightEducation: Int = 4
        var weightLocationExact: Int = 4
        var weightLocationState: Int = 2
        // Novel weighting: cosine similarity of skills/title has higher influence
        var weightSkillCosine: Int = 20
        // Penalties
        var penaltyLocationFar: Int = 6
        // Novel tweak: grant a synergy boost when both exact skills and cosine are strong
        var bonusSynergyHighCosineAndExactSkills: Int = 5
        var weightFieldOfStudyExact: Int = 4
        var weightFieldOfStudyRelated: Int = 2
        var relatedSkillsMap: [String: Set<String>] = [
            "swift": ["kotlin"],
            "kotlin": ["swift"],
            "python": ["machine learning", "sql"],
            "machine learning": ["python", "sql"],
            "sql": ["python", "machine learning"],
            "ui/ux design": []
        ]
        var relatedFieldsOfStudyMap: [String: Set<String>] = [
            // Examples to be extended as dataset grows
            "computer science": ["information technology", "software engineering"],
            "commerce": ["finance", "accounting"],
            "design": ["graphic design", "ui/ux", "visual communication"],
            "sociology": ["rural development", "social work"],
        ]
    }
    private var recConfig = RecommendationConfig()

    // MARK: - Public Match Breakdown API
    struct MatchBreakdown {
        let overallPercent: Int
        let skillsWeightedPercent: Int // out of 40
        let sectorWeightedPercent: Int // out of 30
        let educationWeightedPercent: Int // out of 20
        let locationWeightedPercent: Int // out of 10
        let skillsMatchRatio: Double // 0...1
        let sectorMatchRatio: Double // 0...1
        let educationMatchRatio: Double // 0...1
        let locationMatchRatio: Double // 0...1
        let missingSkills: [String]
        let matchedSkills: [String]
    }

    // Returns weighted breakdown (40/30/20/10) and overall percent 0...100
    func computeMatchBreakdown(for internship: Internship) -> MatchBreakdown? {
        guard let user = userRepository.loadCurrentUser() else { return nil }

        // Skills ratio: exact = 1.0, related = 0.5 credit
        let requiredSkills = internship.requiredSkills.map { ($0.id, normalize($0.name), $0.name) }
        let userSkillNames = Set(user.skills.map { normalize($0.name) })

        var exactCount: Int = 0
        var relatedCount: Int = 0
        var matchedSkillDisplayNames: [String] = []
        var missingSkillDisplayNames: [String] = []

        for (_, normalizedReq, displayName) in requiredSkills {
            if userSkillNames.contains(normalizedReq) {
                exactCount += 1
                matchedSkillDisplayNames.append(displayName)
            } else if hasRelatedSkill(userSkillNames: userSkillNames, requiredSkillName: normalizedReq) {
                relatedCount += 1
                matchedSkillDisplayNames.append(displayName)
            } else {
                missingSkillDisplayNames.append(displayName)
            }
        }

        let denom = max(requiredSkills.count, 1)
        let skillsRatio = min(1.0, (Double(exactCount) + 0.5 * Double(relatedCount)) / Double(denom))

        // Sector ratio
        let sectorMatched = user.interestsSector.contains(where: { $0.id == internship.sector.id })
        let sectorRatio: Double = sectorMatched ? 1.0 : 0.0

        // Education ratio
        let educationOk: Bool
        if let userLevel = qualificationOrder[user.maxQualification], let minLevel = qualificationOrder[internship.minimumQualification] {
            educationOk = userLevel >= minLevel
        } else {
            educationOk = false
        }
        let educationRatio: Double = educationOk ? 1.0 : 0.0

        // Location ratio: 1.0 exact location, 0.8 same state, 0.0 otherwise
        let preferred = user.locationPreferences
        let exact = preferred.contains(where: { $0.id == internship.location.id })
        let sameState = preferred.contains(where: { $0.state.caseInsensitiveCompare(internship.location.state) == .orderedSame })
        let locationRatio: Double = exact ? 1.0 : (sameState ? 0.8 : 0.0)

        // Weights
        let wSkills = 40.0
        let wSector = 30.0
        let wEducation = 20.0
        let wLocation = 10.0

        let skillsWeighted = Int(round(skillsRatio * wSkills))
        let sectorWeighted = Int(round(sectorRatio * wSector))
        let educationWeighted = Int(round(educationRatio * wEducation))
        let locationWeighted = Int(round(locationRatio * wLocation))
        let overall = min(100, skillsWeighted + sectorWeighted + educationWeighted + locationWeighted)

        return MatchBreakdown(
            overallPercent: overall,
            skillsWeightedPercent: skillsWeighted,
            sectorWeightedPercent: sectorWeighted,
            educationWeightedPercent: educationWeighted,
            locationWeightedPercent: locationWeighted,
            skillsMatchRatio: skillsRatio,
            sectorMatchRatio: sectorRatio,
            educationMatchRatio: educationRatio,
            locationMatchRatio: locationRatio,
            missingSkills: missingSkillDisplayNames,
            matchedSkills: matchedSkillDisplayNames
        )
    }

    init() {
        load()
        bind()
        loadSavedInternships()
    }

    func load() {
        internships = InternshipDummy.all
        allSkills = Array(Set(InternshipDummy.all.flatMap { $0.requiredSkills })).sorted { $0.name < $1.name }
        allLocations = Array(Set(InternshipDummy.all.map { $0.location })).sorted { $0.state < $1.state }
        filtered = internships
    }

    func refresh() async {
        // Simulate refresh on dummy data
        try? await Task.sleep(nanoseconds: 400_000_000)
        await MainActor.run { 
            // Only refresh the data source but maintain filters
            self.internships = InternshipDummy.all
            self.allSkills = Array(Set(InternshipDummy.all.flatMap { $0.requiredSkills })).sorted { $0.name < $1.name }
            self.allLocations = Array(Set(InternshipDummy.all.map { $0.location })).sorted { $0.state < $1.state }
            // Re-apply existing filters instead of resetting them
            self.applyFilters()
        }
    }
    
    func setViewMode(recommended: Bool) {
        isRecommendedMode = recommended
        // Filters will be reapplied via the publisher binding
    }

    private func bind() {
        Publishers.CombineLatest4($searchText.removeDuplicates(), $selectedSkillIds.removeDuplicates(), $selectedLocationIds.removeDuplicates(), $isRecommendedMode.removeDuplicates())
            .debounce(for: .milliseconds(120), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    private func applyFilters() {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        // Step 1: Base filtering using search text and selected filters
        let baseFiltered = internships.filter { internship in
            // Text search filter
            var matchesText = true
            if !text.isEmpty {
                let haystack = [
                    internship.company.name.lowercased(),
                    internship.title.lowercased(),
                    internship.location.state.lowercased(),
                    internship.location.district.lowercased(),
                    internship.location.city?.lowercased() ?? ""
                ] + internship.requiredSkills.map { $0.name.lowercased() }

                matchesText = haystack.contains { $0.contains(text) }
            }

            // Selected filters
            let matchesSkills = selectedSkillIds.isEmpty || !selectedSkillIds.isDisjoint(with: Set(internship.requiredSkills.map { $0.id }))
            let matchesLocations = selectedLocationIds.isEmpty || selectedLocationIds.contains(internship.location.id)

            return matchesText && matchesSkills && matchesLocations
        }

        // Step 2: If Recommended mode, score, sort and limit; else just assign
        if isRecommendedMode, let user = userRepository.loadCurrentUser() {
            let scored: [(internship: Internship, score: Int)] = baseFiltered.map { ($0, recommendationScore(for: $0, user: user)) }
            let positive = scored.filter { $0.score > 0 }
            let sorted = (positive.isEmpty ? scored : positive)
                .sorted { lhs, rhs in
                    if lhs.score == rhs.score {
                        return lhs.internship.title < rhs.internship.title
                    }
                    return lhs.score > rhs.score
                }
            filtered = Array(sorted.prefix(topRecommendationLimit).map { $0.internship })
        } else {
            filtered = baseFiltered
        }
    }
    
    // Remove an internship from the filtered list
    func removeInternship(_ internship: Internship) {
        if let index = filtered.firstIndex(where: { $0.id == internship.id }) {
            filtered.remove(at: index)
        }
    }
    
    // Add an internship back to the filtered list
    func addInternship(_ internship: Internship) {
        // Check if the internship is already in the filtered list
        if !filtered.contains(where: { $0.id == internship.id }) {
            // Check if the internship passes current filters
            let shouldAdd = applyFiltersToInternship(internship)
            if shouldAdd {
                filtered.append(internship)
                // Maintain ordering
                if isRecommendedMode, let user = userRepository.loadCurrentUser() {
                    let ranked = filtered.map { ($0, recommendationScore(for: $0, user: user)) }
                        .sorted { lhs, rhs in
                            if lhs.1 == rhs.1 { return lhs.0.title < rhs.0.title }
                            return lhs.1 > rhs.1
                        }
                        .map { $0.0 }
                    filtered = Array(ranked.prefix(topRecommendationLimit))
                } else {
                    filtered.sort { $0.title < $1.title }
                }
            }
        }
    }
    
    func toggleSaveInternship(_ internship: Internship) {
        if userRepository.toggleSaveInternship(internship) {
            loadSavedInternships()
        }
    }
    
    func loadSavedInternships() {
        savedInternships = userRepository.loadSavedInternships()
    }
    
    func isInternshipSaved(_ internship: Internship) -> Bool {
        return savedInternships.contains(where: { $0.id == internship.id })
    }
    
    // Helper method to check if an internship passes current filters
    private func applyFiltersToInternship(_ internship: Internship) -> Bool {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        // Text search filter
        var matchesText = true
        if !text.isEmpty {
            let haystack = [
                internship.company.name.lowercased(),
                internship.title.lowercased(),
                internship.location.state.lowercased(),
                internship.location.district.lowercased(),
                internship.location.city?.lowercased() ?? ""
            ] + internship.requiredSkills.map { $0.name.lowercased() }

            matchesText = haystack.contains { $0.contains(text) }
        }

        // Selected filters
        let matchesSkills = selectedSkillIds.isEmpty || !selectedSkillIds.isDisjoint(with: Set(internship.requiredSkills.map { $0.id }))
        let matchesLocations = selectedLocationIds.isEmpty || selectedLocationIds.contains(internship.location.id)

        if !matchesText || !matchesSkills || !matchesLocations { return false }

        if isRecommendedMode, let user = userRepository.loadCurrentUser() {
            let score = recommendationScore(for: internship, user: user)
            return score > 0
        }

        return true
    }

    // MARK: - Recommendation Scoring
    private func recommendationScore(for internship: Internship, user: User) -> Int {
        // NOTE: Enhanced scoring combines rule-based matching with comprehensive cosine similarity
        // across skills, sector, location, and fields of study for better semantic matching
        var score = 0
        var cosineScores: [String: Double] = [:]

        print("🔍 Computing recommendation score for: \(internship.title)")
        print("👤 User: \(user.firstName) \(user.lastName)")

        // 1. SKILLS MATCHING - Rule-based + Cosine similarity
        let userSkills = user.skills
        let userSkillNames = Set(userSkills.map { normalize($0.name) })
        let requiredSkillNames = internship.requiredSkills.map { normalize($0.name) }

        var exactMatchesCount = 0
        var relatedMatchesCount = 0
        
        // Rule-based skill matching
        for required in requiredSkillNames {
            if userSkillNames.contains(required) {
                score += recConfig.weightSkillExact
                exactMatchesCount += 1
                print("✅ Exact skill match: \(required)")
            } else if hasRelatedSkill(userSkillNames: userSkillNames, requiredSkillName: required) {
                score += recConfig.weightSkillRelated
                relatedMatchesCount += 1
                print("🔗 Related skill match: \(required)")
            }
        }
        
        // Cosine similarity for skills
        let userSkillSentence = user.skills.map { normalize($0.name) }.joined(separator: " ")
        let requiredSkillSentence = internship.requiredSkills.map { normalize($0.name) }.joined(separator: " ")
        let skillCosine = cosineSimilarity(between: userSkillSentence, and: requiredSkillSentence)
        cosineScores["skills"] = skillCosine
        score += Int(round(skillCosine * Double(recConfig.weightSkillCosine)))
        print("📊 Skills cosine similarity: \(String(format: "%.3f", skillCosine))")

        // Apply diminishing returns on related matches beyond 3
        if relatedMatchesCount > 3 {
            score -= (relatedMatchesCount - 3)
        }

        // 2. SECTOR MATCHING - Rule-based + Cosine similarity
        let sectorMatched = user.interestsSector.contains(where: { $0.id == internship.sector.id })
        if sectorMatched {
            score += recConfig.weightSector
            print("✅ Exact sector match: \(internship.sector.name)")
        }
        
        // Cosine similarity for sector
        let userSectorSentence = user.interestsSector.map { normalize($0.name) }.joined(separator: " ")
        let internshipSectorSentence = internship.sector.name
        let sectorCosine = cosineSimilarity(between: userSectorSentence, and: internshipSectorSentence)
        cosineScores["sector"] = sectorCosine
        score += Int(round(sectorCosine * Double(recConfig.weightSector)))
        print("📊 Sector cosine similarity: \(String(format: "%.3f", sectorCosine))")

        // 3. EDUCATION MATCHING - Rule-based only (qualification levels)
        if let userLevel = qualificationOrder[user.maxQualification], let minLevel = qualificationOrder[internship.minimumQualification], userLevel >= minLevel {
            score += recConfig.weightEducation
            print("✅ Education qualification match: \(user.maxQualification) >= \(internship.minimumQualification)")
        } else {
            print("❌ Education qualification mismatch: \(user.maxQualification) < \(internship.minimumQualification)")
        }

        // 4. LOCATION MATCHING - Rule-based + Cosine similarity
        let preferred = user.locationPreferences
        let exact = preferred.contains(where: { $0.id == internship.location.id })
        let sameState = preferred.contains(where: { $0.state.caseInsensitiveCompare(internship.location.state) == .orderedSame })
        
        if exact {
            score += recConfig.weightLocationExact
            print("✅ Exact location match: \(internship.location.city ?? internship.location.district)")
        } else if sameState {
            score += recConfig.weightLocationState
            print("🔗 Same state location match: \(internship.location.state)")
        } else {
            score -= recConfig.penaltyLocationFar
            print("❌ Location mismatch: \(internship.location.state)")
        }
        
        // Cosine similarity for location
        let userLocationSentence = user.locationPreferences.map { 
            "\(normalize($0.city ?? $0.district)) \(normalize($0.state))" 
        }.joined(separator: " ")
        let internshipLocationSentence = "\(normalize(internship.location.city ?? internship.location.district)) \(normalize(internship.location.state))"
        let locationCosine = cosineSimilarity(between: userLocationSentence, and: internshipLocationSentence)
        cosineScores["location"] = locationCosine
        score += Int(round(locationCosine * Double(recConfig.weightLocationState)))
        print("📊 Location cosine similarity: \(String(format: "%.3f", locationCosine))")

        // 5. FIELDS OF STUDY MATCHING - Rule-based + Cosine similarity
        if let userFields = user.fieldsOfStudy, let acceptedFields = internship.acceptedFieldsOfStudy {
            let userFieldNames = Set(userFields.map { normalize($0.name) })
            let acceptedNames = acceptedFields.map { normalize($0.name) }
            var fieldMatched = false
            
            for requiredField in acceptedNames {
                if userFieldNames.contains(requiredField) {
                    score += recConfig.weightFieldOfStudyExact
                    fieldMatched = true
                    print("✅ Exact field of study match: \(requiredField)")
                } else if hasRelatedField(userFieldNames: userFieldNames, requiredFieldName: requiredField) {
                    score += recConfig.weightFieldOfStudyRelated
                    fieldMatched = true
                    print("🔗 Related field of study match: \(requiredField)")
                }
            }
            
            // Cosine similarity for fields of study
            let userFieldSentence = userFields.map { normalize($0.name) }.joined(separator: " ")
            let internshipFieldSentence = acceptedFields.map { normalize($0.name) }.joined(separator: " ")
            let fieldCosine = cosineSimilarity(between: userFieldSentence, and: internshipFieldSentence)
            cosineScores["fields"] = fieldCosine
            score += Int(round(fieldCosine * Double(recConfig.weightFieldOfStudyRelated)))
            print("📊 Fields of study cosine similarity: \(String(format: "%.3f", fieldCosine))")
        }

        // 6. OVERALL SEMANTIC MATCHING - Enhanced cosine similarity
        let userProfileSentence = [
            user.skills.map { normalize($0.name) }.joined(separator: " "),
            user.interestsSector.map { normalize($0.name) }.joined(separator: " "),
            user.locationPreferences.map { normalize($0.city ?? $0.district) }.joined(separator: " "),
            user.fieldsOfStudy?.map { normalize($0.name) }.joined(separator: " ") ?? ""
        ].filter { !$0.isEmpty }.joined(separator: " ")
        
        let internshipProfileSentence = [
            internship.title,
            internship.requiredSkills.map { normalize($0.name) }.joined(separator: " "),
            internship.sector.name,
            "\(internship.location.city ?? internship.location.district) \(internship.location.state)",
            internship.acceptedFieldsOfStudy?.map { normalize($0.name) }.joined(separator: " ") ?? ""
        ].filter { !$0.isEmpty }.joined(separator: " ")
        
        let overallCosine = cosineSimilarity(between: userProfileSentence, and: internshipProfileSentence)
        cosineScores["overall"] = overallCosine
        score += Int(round(overallCosine * Double(recConfig.weightSkillCosine)))
        print("📊 Overall profile cosine similarity: \(String(format: "%.3f", overallCosine))")

        // 7. SYNERGY BONUS - High cosine similarity + good exact matches
        let avgCosine = cosineScores.values.reduce(0, +) / Double(cosineScores.count)
        if avgCosine >= 0.6 && exactMatchesCount >= 1 {
            score += recConfig.bonusSynergyHighCosineAndExactSkills
            print("🎯 Synergy bonus applied: avg cosine \(String(format: "%.3f", avgCosine)), exact matches: \(exactMatchesCount)")
        }

        print("📈 Final score: \(score)")
        print("📊 Cosine scores breakdown: \(cosineScores)")
        print("---")

        return score
    }

    private func hasRelatedSkill(userSkillNames: Set<String>, requiredSkillName: String) -> Bool {
        // From curated map
        if let related = recConfig.relatedSkillsMap[requiredSkillName] {
            if !related.isDisjoint(with: userSkillNames) { return true }
        }
        // Fallback: token overlap or containment heuristic
        for candidate in userSkillNames {
            if candidate.contains(requiredSkillName) || requiredSkillName.contains(candidate) { return true }
            let candidateTokens = Set(candidate.split(separator: " ").map(String.init))
            let requiredTokens = Set(requiredSkillName.split(separator: " ").map(String.init))
            if !candidateTokens.isDisjoint(with: requiredTokens) { return true }
        }
        return false
    }

    private func hasRelatedField(userFieldNames: Set<String>, requiredFieldName: String) -> Bool {
        if let related = recConfig.relatedFieldsOfStudyMap[requiredFieldName] {
            if !related.isDisjoint(with: userFieldNames) { return true }
        }
        for candidate in userFieldNames {
            if candidate.contains(requiredFieldName) || requiredFieldName.contains(candidate) { return true }
            let candidateTokens = Set(candidate.split(separator: " ").map(String.init))
            let requiredTokens = Set(requiredFieldName.split(separator: " ").map(String.init))
            if !candidateTokens.isDisjoint(with: requiredTokens) { return true }
        }
        return false
    }

    private func normalize(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Local Cosine Similarity (token frequency based)
    // Rationale: lightweight, offline cosine on token counts. Good enough for ranking; avoids network/
    // privacy costs. For production, swap with an embeddings service and cache results.
    private func cosineSimilarity(between lhs: String, and rhs: String) -> Double {
        let tokensL = tokenize(lhs)
        let tokensR = tokenize(rhs)
        if tokensL.isEmpty || tokensR.isEmpty { return 0 }
        let vocab = Set(tokensL.keys).union(Set(tokensR.keys))
        var dot: Double = 0
        var magL: Double = 0
        var magR: Double = 0
        for term in vocab {
            let l = Double(tokensL[term] ?? 0)
            let r = Double(tokensR[term] ?? 0)
            dot += l * r
            magL += l * l
            magR += r * r
        }
        let denom = (magL.squareRoot() * magR.squareRoot())
        if denom == 0 { return 0 }
        return max(0, min(1, dot / denom))
    }

    private func tokenize(_ text: String) -> [String: Int] {
        var counts: [String: Int] = [:]
        let separators = CharacterSet.alphanumerics.inverted
        text.lowercased().components(separatedBy: separators).forEach { token in
            let t = token.trimmingCharacters(in: .whitespacesAndNewlines)
            guard t.count > 1 else { return }
            counts[t, default: 0] += 1
        }
        return counts
    }

    

    // MARK: - Sentence Similarity --Cosine
    func getSimilarityBatch(_ sourceSentence: String,
                            _ sentences: [String],
                            completion: @escaping ([Double]?) -> Void) {
        
        print("🚀 Starting sentence similarity batch processing...")
        print("📝 Source sentence: \(sourceSentence)")
        print("📝 Target sentences count: \(sentences.count)")
        for (index, sentence) in sentences.enumerated() {
            print("   \(index + 1). \(sentence)")
        }
        
        let apiKey = "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" // replace with your Hugging Face token
        let model = "sentence-transformers/all-MiniLM-L6-v2"
        
        guard let url = URL(string: "https://api-inference.huggingface.co/models/\(model)") else {
            print("❌ Invalid URL for model: \(model)")
            completion(nil)
            return
        }
        
        let requestBody: [String: Any] = [
            "inputs": [
                "source_sentence": sourceSentence,
                "sentences": sentences
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("❌ Error serializing JSON request body")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        request.timeoutInterval = 30.0
        
        print("🌐 Making API request to Hugging Face...")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error:", error.localizedDescription)
                    completion(nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("⚠️ Non-200 status code received")
                    }
                }
                
                guard let data = data else {
                    print("❌ No data received from API")
                    completion(nil)
                    return
                }
                
                let raw = String(data: data, encoding: .utf8) ?? "nil"
                print("🔍 Raw API Response: \(raw)")
                
                // Decode Hugging Face JSON: {"scores": [..]}
                do {
                    if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("📊 Parsed JSON structure: \(dict.keys)")
                        
                        if let scores = dict["scores"] as? [Double] {
                            print("✅ Successfully extracted \(scores.count) similarity scores:")
                            for (index, score) in scores.enumerated() {
                                print("   \(index + 1). \(String(format: "%.4f", score))")
                            }
                            completion(scores)
                        } else if let error = dict["error"] as? String {
                            print("❌ API Error: \(error)")
                            completion(nil)
                        } else {
                            print("⚠️ Unexpected response structure - no 'scores' key found")
                            print("📋 Available keys: \(dict.keys)")
                            completion(nil)
                        }
                    } else {
                        print("❌ Failed to parse JSON response")
                        completion(nil)
                    }
                } catch {
                    print("❌ JSON parse error:", error.localizedDescription)
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    // MARK: - Enhanced Cosine Similarity Demo
    func demonstrateCosineSimilarity() {
        print("🧪 Demonstrating Enhanced Cosine Similarity Scoring")
        print(String(repeating: "=", count: 50))
        
        guard let user = userRepository.loadCurrentUser() else {
            print("❌ No user found for demonstration")
            return
        }
        
        print("👤 User Profile:")
        print("   Skills: \(user.skills.map { $0.name }.joined(separator: ", "))")
        print("   Sectors: \(user.interestsSector.map { $0.name }.joined(separator: ", "))")
        print("   Locations: \(user.locationPreferences.map { "\($0.city ?? $0.district), \($0.state)" }.joined(separator: "; "))")
        print("   Fields: \(user.fieldsOfStudy?.map { $0.name }.joined(separator: ", ") ?? "None")")
        print("   Education: \(user.maxQualification)")
        print("")
        
        // Test with first few internships
        let testInternships = Array(internships.prefix(3))
        
        for internship in testInternships {
            print("🏢 Testing with: \(internship.title)")
            print("   Company: \(internship.company.name)")
            print("   Required Skills: \(internship.requiredSkills.map { $0.name }.joined(separator: ", "))")
            print("   Sector: \(internship.sector.name)")
            print("   Location: \(internship.location.city ?? internship.location.district), \(internship.location.state)")
            print("   Min Education: \(internship.minimumQualification)")
            print("")
            
            // Compute and display detailed scoring
            let _ = recommendationScore(for: internship, user: user)
            print("")
        }
        
        print(String(repeating: "=", count: 50))
        print("✅ Cosine similarity demonstration completed")
    }

    // MARK: - Batch Similarity Testing
    func testBatchSimilarity() {
        print("🧪 Testing Batch Sentence Similarity")
        print(String(repeating: "=", count: 30))
        
        let sourceSentence = "python machine learning data science"
        let testSentences = [
            "python programming artificial intelligence",
            "swift ios development mobile apps",
            "machine learning data analysis statistics",
            "ui ux design user interface",
            "sql database management backend"
        ]
        
        getSimilarityBatch(sourceSentence, testSentences) { scores in
            if let scores = scores {
                print("✅ Batch similarity test completed successfully!")
                print("📊 Results:")
                for (index, score) in scores.enumerated() {
                    print("   \(testSentences[index]): \(String(format: "%.4f", score))")
                }
            } else {
                print("❌ Batch similarity test failed")
            }
        }
    }
}


