//
//  InternshipFilterSheet.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct InternshipFilterSheet: View {
    @Binding var selectedSkillIds: Set<UUID>
    @Binding var selectedLocationIds: Set<UUID>

    let allSkills: [Skill]
    let allLocations: [Location]

    @Environment(\.dismiss) private var dismiss
    @State private var showSkillsSelection = false
    @State private var showLocationSelection = false

    var body: some View {
        NavigationStack {
            List {
                // Skills Section
                Section {
                    NavigationLink(destination: SkillsSelectionView(
                        selectedSkillIds: $selectedSkillIds,
                        allSkills: allSkills
                    )) {
                        HStack {
                            Text("Skills")
                            Spacer()
                            Text("\(selectedSkillIds.count) selected")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Show selected skills as pills
                    if !selectedSkillIds.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(allSkills.filter { selectedSkillIds.contains($0.id) }) { skill in
                                    SkillPill(skill: skill) {
                                        selectedSkillIds.remove(skill.id)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // Locations Section
                Section {
                    NavigationLink(destination: LocationSelectionView(
                        selectedLocationIds: $selectedLocationIds,
                        allLocations: allLocations
                    )) {
                        HStack {
                            Text("Location")
                            Spacer()
                            Text("\(selectedLocationIds.count) selected")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Show selected locations as pills
                    if !selectedLocationIds.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(allLocations.filter { selectedLocationIds.contains($0.id) }) { location in
                                    LocationPill(location: location) {
                                        selectedLocationIds.remove(location.id)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedSkillIds.removeAll()
                        selectedLocationIds.removeAll()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Skills Selection View
struct SkillsSelectionView: View {
    @Binding var selectedSkillIds: Set<UUID>
    let allSkills: [Skill]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(allSkills) { skill in
                Button {
                    if selectedSkillIds.contains(skill.id) {
                        selectedSkillIds.remove(skill.id)
                    } else {
                        selectedSkillIds.insert(skill.id)
                    }
                } label: {
                    HStack {
                        Text(skill.name)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedSkillIds.contains(skill.id) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Select Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

// MARK: - Location Selection View
struct LocationSelectionView: View {
    @Binding var selectedLocationIds: Set<UUID>
    let allLocations: [Location]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(allLocations) { location in
                Button {
                    // Single selection for location
                    selectedLocationIds.removeAll()
                    selectedLocationIds.insert(location.id)
                } label: {
                    HStack {
                        Text("\(location.city ?? location.district), \(location.state)")
                            .foregroundStyle(.primary)
                        Spacer()
                        if selectedLocationIds.contains(location.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

// MARK: - Pill Components
struct SkillPill: View {
    let skill: Skill
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(skill.name)
                .font(.caption)
                .padding(.leading, 8)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
            .padding(.trailing, 4)
        }
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    Capsule()
                        .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct LocationPill: View {
    let location: Location
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(location.city ?? location.district), \(location.state)")
                .font(.caption)
                .padding(.leading, 8)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
            .padding(.trailing, 4)
        }
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    Capsule()
                        .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}


