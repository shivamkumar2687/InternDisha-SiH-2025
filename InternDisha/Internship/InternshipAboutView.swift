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
                        Label(
                            String(localized: "%@")
                                .replacingPlaceholders(with: internship.location.city ?? internship.location.district),
                            systemImage: "mappin.and.ellipse"
                        )
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
                            Text(String(localized: "Internship ID"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(String(localized: "PMIS-%@").replacingPlaceholders(with: String(internship.id.uuidString.prefix(8))))
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text(String(localized: "Internship Title"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(internship.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text(String(localized: "Minimum Qualification"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(localizedQualification(internship.minimumQualification))
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text(String(localized: "Number of Openings"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(String(localized: "%d").replacingPlaceholders(with: internship.numberOfOpenings))
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.orange)
                        }
                        
                        HStack {
                            Text(String(localized: "Area/Field"))
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
                        Text(String(localized: "Skill %d").replacingPlaceholders(with: 1))
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
                        ForEach(1..<min(internship.requiredSkills.count, 3), id: \.self) { index in
                            HStack {
                                Text(String(localized: "Skill %d").replacingPlaceholders(with: index + 1))
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
                                Text(String(localized: "and %d more skills").replacingPlaceholders(with: internship.requiredSkills.count - 3))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                        }
                    }
                    
                    // Description text
                    Text(String(localized: "Description"))
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
            .navigationTitle(String(localized: "About"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) {
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
                    Text(String(localized: "Predict Chance"))
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
                            Text(String(localized: "🎯 Match Score:"))
                                .font(.body.weight(.semibold))
                            Text(String(localized: "%d%%").replacingPlaceholders(with: breakdown.overallPercent))
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
                            .accessibilityLabel(String(localized: "Weighting info"))
                        }

                        // Breakdown bars
                        breakdownRow(
                            title: String(localized: "Skills"),
                            ratio: breakdown.skillsMatchRatio,
                            tint: .blue,
                            detail: String(localized: "%d/40").replacingPlaceholders(with: breakdown.skillsWeightedPercent)
                        )
                        breakdownRow(
                            title: String(localized: "Sector"),
                            ratio: breakdown.sectorMatchRatio,
                            tint: .orange,
                            detail: String(localized: "%d/30").replacingPlaceholders(with: breakdown.sectorWeightedPercent)
                        )
                        breakdownRow(
                            title: String(localized: "Education"),
                            ratio: breakdown.educationMatchRatio,
                            tint: .green,
                            detail: String(localized: "%d/20").replacingPlaceholders(with: breakdown.educationWeightedPercent)
                        )
                        breakdownRow(
                            title: String(localized: "Location"),
                            ratio: breakdown.locationMatchRatio,
                            tint: .purple,
                            detail: String(localized: "%d/10").replacingPlaceholders(with: breakdown.locationWeightedPercent)
                        )

                        // Tips
                        VStack(alignment: .leading, spacing: 6) {
                            if breakdown.skillsMatchRatio >= 0.7 {
                                tipRow(text: String(localized: "✅ Strong skills match!"))
                            } else {
                                if let firstMissing = breakdown.missingSkills.first {
                                    if breakdown.missingSkills.count == 1 {
                                        tipRow(
                                            text: String(localized: "⚡ You’re missing only 1 skill (%@) to reach 100%% match.")
                                                .replacingPlaceholders(with: firstMissing)
                                        )
                                    } else {
                                        tipRow(
                                            text: String(localized: "⚡ Add %@ and %d more to boost your score.")
                                                .replacingPlaceholders(with: firstMissing, breakdown.missingSkills.count - 1)
                                        )
                                    }
                                } else {
                                    tipRow(text: String(localized: "💡 Add more relevant skills to improve your match."))
                                }
                            }

                            if breakdown.sectorMatchRatio < 1.0 {
                                tipRow(text: String(localized: "💡 Follow this sector to get better recommendations."))
                            }

                            if breakdown.locationMatchRatio < 1.0 {
                                tipRow(text: String(localized: "📍 Add preferred locations matching this state for higher chance."))
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.systemGray6)))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    Text(String(localized: "Sign in and set up your profile to see your match score."))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(.systemGray6)))
                        .transition(.opacity)
                }
            }
        }
        .padding(.top, 8)
        .alert(String(localized: "Weighted"), isPresented: $showWeightInfo) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(String(localized: "Match Score is weighted: Skills 40%%, Sector 30%%, Education 20%%, Location 10%%."))
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

// MARK: - Helpers
private extension String {
    func replacingPlaceholders(with value: some CVarArg) -> String {
        String(format: self, value)
    }
    func replacingPlaceholders(with value1: some CVarArg, _ value2: some CVarArg) -> String {
        String(format: self, value1, value2)
    }
}

private func localizedQualification(_ q: Qualification) -> String {
    switch q {
    case .twelfth:
        return String(localized: "12th")
    case .bachelors:
        return String(localized: "Bachelors")
    case .masters:
        return String(localized: "Masters")
    }
}
