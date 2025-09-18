//
//  EditProfileSheet.swift
//  InternDisha
//
//  Created by AI Assistant on 08/09/25.
//

import SwiftUI

struct EditProfileSheet: View {
    var initialUser: User
    var onSave: (User) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var selectedSkills: Set<UUID> = []
    @State private var selectedSector: Sector? = SectorDummy.all.first
    @State private var selectedArea: Area? = SectorDummy.all.first?.areas.first
    @State private var selectedLocations: Set<UUID> = []
    @State private var selectedQualification: Qualification

    // Search states (mirror signup)
    @State private var skillsSearchText: String = ""
    @State private var locationsSearchText: String = ""

    private let allSkills = SkillDummy.all
    private let allSectors = SectorDummy.all
    private let allLocations = LocationDummy.all

    init(initialUser: User, onSave: @escaping (User) -> Void) {
        self.initialUser = initialUser
        self.onSave = onSave
        _selectedQualification = State(initialValue: initialUser.maxQualification)

        // Preselect by stable attributes instead of IDs (IDs may differ across runs)
        let userSkillNames = Set(initialUser.skills.map { $0.name.lowercased() })
        let preselectedSkillIds = Set(SkillDummy.all.filter { userSkillNames.contains($0.name.lowercased()) }.map { $0.id })
        _selectedSkills = State(initialValue: preselectedSkillIds)

        if let firstInterest = initialUser.interestsSector.first,
           let matchedSector = SectorDummy.all.first(where: { $0.name.caseInsensitiveCompare(firstInterest.name) == .orderedSame }) {
            _selectedSector = State(initialValue: matchedSector)
            if let areaName = firstInterest.areas.first?.name,
               let matchedArea = matchedSector.areas.first(where: { $0.name.caseInsensitiveCompare(areaName) == .orderedSame }) {
                _selectedArea = State(initialValue: matchedArea)
            } else {
                _selectedArea = State(initialValue: matchedSector.areas.first)
            }
        } else {
            _selectedSector = State(initialValue: SectorDummy.all.first)
            _selectedArea = State(initialValue: SectorDummy.all.first?.areas.first)
        }

        let preselectedLocationIds = Set(LocationDummy.all.filter { loc in
            initialUser.locationPreferences.contains { userLoc in
                userLoc.state.caseInsensitiveCompare(loc.state) == .orderedSame &&
                userLoc.district.caseInsensitiveCompare(loc.district) == .orderedSame &&
                ((userLoc.city ?? "").caseInsensitiveCompare(loc.city ?? "") == .orderedSame)
            }
        }.map { $0.id })
        _selectedLocations = State(initialValue: preselectedLocationIds)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Qualification (like signup)
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "Education")
                        Picker("Qualification", selection: $selectedQualification) {
                            ForEach(Qualification.allCases, id: \.self) { q in
                                Text(q.rawValue).tag(q)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Skills (with search + chip toggles like signup)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Skills")
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search skills...", text: $skillsSearchText)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            if !skillsSearchText.isEmpty {
                                Button { skillsSearchText = "" } label: {
                                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(filteredSkills) { skill in
                                SkillToggle(
                                    skill: skill,
                                    isSelected: selectedSkills.contains(skill.id),
                                    onToggle: { isSelected in
                                        if isSelected { selectedSkills.insert(skill.id) } else { selectedSkills.remove(skill.id) }
                                    }
                                )
                            }
                        }

                        if filteredSkills.isEmpty && !skillsSearchText.isEmpty {
                            Text("No skills found matching '\\(skillsSearchText)'")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 12)
                        }
                    }

                    // Interests (single sector + area pickers like signup)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Areas of Interest")
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sector").font(.subheadline).fontWeight(.medium)
                            Picker("Sector", selection: Binding(
                                get: { selectedSector?.id ?? SectorDummy.all.first!.id },
                                set: { newId in
                                    selectedSector = allSectors.first(where: { $0.id == newId })
                                    selectedArea = selectedSector?.areas.first
                                }
                            )) {
                                ForEach(allSectors) { sector in
                                    Text(sector.name).tag(sector.id)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        if let areas = selectedSector?.areas {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Area").font(.subheadline).fontWeight(.medium)
                                Picker("Area", selection: Binding(
                                    get: { selectedArea?.id ?? areas.first!.id },
                                    set: { newId in
                                        selectedArea = areas.first(where: { $0.id == newId })
                                    }
                                )) {
                                    ForEach(areas) { area in
                                        Text(area.name).tag(area.id)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }

                    // Locations (search + toggle list like signup)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Location Preferences")
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                            TextField("Search locations...", text: $locationsSearchText)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            if !locationsSearchText.isEmpty {
                                Button { locationsSearchText = "" } label: {
                                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                            ForEach(filteredLocations) { loc in
                                LocationToggle(
                                    location: loc,
                                    isSelected: selectedLocations.contains(loc.id),
                                    onToggle: { isSelected in
                                        if isSelected { selectedLocations.insert(loc.id) } else { selectedLocations.remove(loc.id) }
                                    }
                                )
                            }
                        }

                        if filteredLocations.isEmpty && !locationsSearchText.isEmpty {
                            Text("No locations found matching '\\(locationsSearchText)'")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 12)
                        }
                    }

                    Spacer(minLength: 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { save() }.fontWeight(.semibold) }
            }
        }
    }

    private func save() {
        let interestSectors: [Sector]
        if let sector = selectedSector, let area = selectedArea {
            interestSectors = [Sector(id: sector.id, name: sector.name, areas: [area])]
        } else if let sector = selectedSector {
            interestSectors = [sector]
        } else {
            interestSectors = []
        }

        let updated = User(
            id: initialUser.id,
            firstName: initialUser.firstName,
            lastName: initialUser.lastName,
            dateOfBirth: initialUser.dateOfBirth,
            mobile: initialUser.mobile,
            email: initialUser.email,
            password: initialUser.password,
            maxQualification: selectedQualification,
            role: initialUser.role,
            skills: allSkills.filter { selectedSkills.contains($0.id) },
            interestsSector: interestSectors,
            locationPreferences: allLocations.filter { selectedLocations.contains($0.id) },
            fieldsOfStudy: initialUser.fieldsOfStudy,
            companyName: initialUser.companyName,
            companyWebsite: initialUser.companyWebsite,
            companyDescription: initialUser.companyDescription,
            companySize: initialUser.companySize,
            industry: initialUser.industry,
            jobTitle: initialUser.jobTitle,
            department: initialUser.department
        )
        onSave(updated)
        dismiss()
    }

    private var filteredSkills: [Skill] {
        if skillsSearchText.isEmpty { return allSkills }
        return allSkills.filter { $0.name.localizedCaseInsensitiveContains(skillsSearchText) }
    }

    private var filteredLocations: [Location] {
        if locationsSearchText.isEmpty { return allLocations }
        let q = locationsSearchText.lowercased()
        return allLocations.filter { loc in
            loc.state.lowercased().contains(q) ||
            loc.district.lowercased().contains(q) ||
            (loc.city?.lowercased().contains(q) ?? false)
        }
    }
}

#Preview {
    EditProfileSheet(
        initialUser: User(
            id: UUID(),
            firstName: "Demo",
            lastName: "User",
            dateOfBirth: Date(),
            mobile: "9999999999",
            email: "demo@intern.com",
            password: "password",
            maxQualification: .bachelors,
            role: .student,
            skills: [],
            interestsSector: SectorDummy.all,
            locationPreferences: LocationDummy.all
        ),
        onSave: { _ in }
    )
}


