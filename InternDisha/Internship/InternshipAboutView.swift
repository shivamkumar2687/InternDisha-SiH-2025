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
    @EnvironmentObject var viewModel: InternshipViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPredict: Bool = false
    @State private var showWeightInfo: Bool = false

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

                    // Predict Chance section
                    predictChanceSection
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


// MARK: - Predict Chance UI
extension InternshipAboutView {
    private var predictChanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.snappy) { showPredict.toggle() }
            } label: {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Predict Chance")
                        .font(.headline)
                    Spacer()
                    Image(systemName: showPredict ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.systemGray6)))
            }
            .buttonStyle(.plain)

            if showPredict {
                if let breakdown = viewModel.computeMatchBreakdown(for: internship) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Overall score with info button
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("🎯 Match Score:")
                                .font(.body.weight(.semibold))
                            Text("\(breakdown.overallPercent)%")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.blue)
                            Spacer()
                            Button {
                                showWeightInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Weighting info")
                        }

                        // Breakdown bars (titles without bracketed weights)
                        breakdownRow(title: "Skills", ratio: breakdown.skillsMatchRatio, tint: .blue, detail: "\(breakdown.skillsWeightedPercent)/40")
                        breakdownRow(title: "Sector", ratio: breakdown.sectorMatchRatio, tint: .orange, detail: "\(breakdown.sectorWeightedPercent)/30")
                        breakdownRow(title: "Education", ratio: breakdown.educationMatchRatio, tint: .green, detail: "\(breakdown.educationWeightedPercent)/20")
                        breakdownRow(title: "Location", ratio: breakdown.locationMatchRatio, tint: .purple, detail: "\(breakdown.locationWeightedPercent)/10")

                        // Tips
                        VStack(alignment: .leading, spacing: 6) {
                            if breakdown.skillsMatchRatio >= 0.7 {
                                tipRow(text: "✅ Strong skills match!")
                            } else {
                                if let firstMissing = breakdown.missingSkills.first {
                                    if breakdown.missingSkills.count == 1 {
                                        tipRow(text: "⚡ You’re missing only 1 skill (\(firstMissing)) to reach 100% match.")
                                    } else {
                                        tipRow(text: "⚡ Add \(firstMissing) and \(breakdown.missingSkills.count - 1) more to boost your score.")
                                    }
                                } else {
                                    tipRow(text: "💡 Add more relevant skills to improve your match.")
                                }
                            }

                            if breakdown.sectorMatchRatio < 1.0 {
                                tipRow(text: "💡 Follow this sector to get better recommendations.")
                            }

                            if breakdown.locationMatchRatio < 1.0 {
                                tipRow(text: "📍 Add preferred locations matching this state for higher chance.")
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.systemGray6)))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    Text("Sign in and set up your profile to see your match score.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.systemGray6)))
                        .transition(.opacity)
                }
            }
        }
        .padding(.top, 8)
        .alert("Weighted", isPresented: $showWeightInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Match Score is weighted: Skills 40%, Sector 30%, Education 20%, Location 10%.")
        }
    }

    private func breakdownRow(title: String, ratio: Double, tint: Color, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(detail)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
            }
            ProgressView(value: min(max(ratio, 0), 1))
                .tint(tint)
        }
    }

    private func tipRow(text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .foregroundStyle(.yellow)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.primary)
        }
    }
}


