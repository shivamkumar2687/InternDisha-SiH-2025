//
//  InternshipAboutView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct InternshipAboutView: View {
    let internship: Internship
    let descriptionText: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Company and Location row
                    HStack(alignment: .firstTextBaseline) {
                        Text(internship.company.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Spacer()
                        Label("\(internship.location.city ?? internship.location.district)", systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Sector badge
                    HStack {
                        Text(internship.sector.name)
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.orange.opacity(0.12))
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        Spacer()
                    }

                    // Title with more prominence
                    if !internship.title.isEmpty {
                        Text(internship.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                            .padding(.top, 4)
                    }
                    
                    // Internship details in key-value format
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Internship ID")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("PMIS-\(internship.id.uuidString.prefix(8))")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text("Internship Title")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(internship.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text("Minimum Qualification")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(internship.minimumQualification.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text("Number of Openings")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(internship.numberOfOpenings)")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text("Area/Field")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(internship.sector.areas.first?.name ?? "")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // Divider for visual separation
                    Divider()
                        .padding(.vertical, 2)

                    // Skills section with key-value format
                    HStack {
                        Text("Skill 1")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        // First skill or empty string if no skills
                        Text(internship.requiredSkills.first?.name ?? "")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.orange)
                    }
                    
                    // Additional skills in key-value format if more than one skill
                    if internship.requiredSkills.count > 1 {
                        ForEach(1..<min(internship.requiredSkills.count, 3)) { index in
                            HStack {
                                Text("Skill \(index + 1)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(internship.requiredSkills[index].name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        // Show count of remaining skills if more than 3
                        if internship.requiredSkills.count > 3 {
                            HStack {
                                Text("+ \(internship.requiredSkills.count - 3) more skills")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                        }
                    }
                    
                    // Description text
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(descriptionText)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


