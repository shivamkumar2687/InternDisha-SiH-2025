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
    
    private let userRepository = UserRepository()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        load()
        bind()
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
        
        // Get user skills and location preferences for recommended mode
        let userSkills = userRepository.loadCurrentUser()?.skills ?? []
        let userLocations = userRepository.loadCurrentUser()?.locationPreferences ?? []
        
        filtered = internships.filter { internship in
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
            
            // Recommended mode filter - match user skills and locations
            var matchesRecommended = true
            if isRecommendedMode {
                // Check if any of the internship's required skills match user's skills
                let hasMatchingSkill = !Set(internship.requiredSkills.map { $0.id }).isDisjoint(with: Set(userSkills.map { $0.id }))
                
                // Check if internship location matches any of user's preferred locations
                let hasMatchingLocation = userLocations.contains { $0.id == internship.location.id }
                
                matchesRecommended = hasMatchingSkill || hasMatchingLocation
            }
            
            return matchesText && matchesSkills && matchesLocations && matchesRecommended
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
                // Sort the filtered list to maintain order
                filtered.sort { $0.title < $1.title }
            }
        }
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
        
        // Recommended mode filter
        var matchesRecommended = true
        if isRecommendedMode {
            // Get user skills and location preferences
            let userSkills = userRepository.loadCurrentUser()?.skills ?? []
            let userLocations = userRepository.loadCurrentUser()?.locationPreferences ?? []
            
            // Check if any of the internship's required skills match user's skills
            let hasMatchingSkill = !Set(internship.requiredSkills.map { $0.id }).isDisjoint(with: Set(userSkills.map { $0.id }))
            
            // Check if internship location matches any of user's preferred locations
            let hasMatchingLocation = userLocations.contains { $0.id == internship.location.id }
            
            matchesRecommended = hasMatchingSkill || hasMatchingLocation
        }
        
        return matchesText && matchesSkills && matchesLocations && matchesRecommended
    }
}


