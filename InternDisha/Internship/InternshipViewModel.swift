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
        var weightSkillExact: Int = 3
        var weightSkillRelated: Int = 1
        var weightSector: Int = 5
        var weightEducation: Int = 4
        var weightLocationExact: Int = 5
        var weightLocationState: Int = 2
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
        var score = 0

        // Skills: +3 for each exact match, +1 for each related (only if not exact matched)
        let userSkills = user.skills
        let userSkillNames = Set(userSkills.map { normalize($0.name) })
        let requiredSkillNames = internship.requiredSkills.map { normalize($0.name) }

        for required in requiredSkillNames {
            if userSkillNames.contains(required) {
                score += recConfig.weightSkillExact
            } else if hasRelatedSkill(userSkillNames: userSkillNames, requiredSkillName: required) {
                score += recConfig.weightSkillRelated
            }
        }

        // Sector match: +5 if user's interests include the internship sector
        if user.interestsSector.contains(where: { $0.id == internship.sector.id }) {
            score += recConfig.weightSector
        }

        // Education: +4 if user qualification >= internship minimum
        if let userLevel = qualificationOrder[user.maxQualification], let minLevel = qualificationOrder[internship.minimumQualification], userLevel >= minLevel {
            score += recConfig.weightEducation
        }

        // Location: +5 exact preferred location match, else +2 if same state
        let preferred = user.locationPreferences
        let exact = preferred.contains(where: { $0.id == internship.location.id })
        if exact {
            score += recConfig.weightLocationExact
        } else if preferred.contains(where: { $0.state.caseInsensitiveCompare(internship.location.state) == .orderedSame }) {
            score += recConfig.weightLocationState
        }

        // Fields of Study: exact or related
        if let userFields = user.fieldsOfStudy, let acceptedFields = internship.acceptedFieldsOfStudy {
            let userFieldNames = Set(userFields.map { normalize($0.name) })
            let acceptedNames = acceptedFields.map { normalize($0.name) }
            var matched = false
            for requiredField in acceptedNames {
                if userFieldNames.contains(requiredField) {
                    score += recConfig.weightFieldOfStudyExact
                    matched = true
                } else if hasRelatedField(userFieldNames: userFieldNames, requiredFieldName: requiredField) {
                    score += recConfig.weightFieldOfStudyRelated
                    matched = true
                }
            }
            // 'matched' is not used further; retained for readability if needed later
            _ = matched
        }

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
}


