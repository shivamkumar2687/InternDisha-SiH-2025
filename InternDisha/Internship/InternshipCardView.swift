//
//  InternshipCardView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct InternshipCardView: View {
    let internship: Internship
    let applyAction: () -> Void
    let aboutAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) { // Reduced spacing for compact layout
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

            // Buttons with proper alignment and more height
            HStack(spacing: 12) {
                Button(action: applyAction) {
                    Text("Apply")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10) // Moderate vertical padding
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                Button(action: aboutAction) {
                    Text("About")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10) // Moderate vertical padding
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(16) // Moderate padding for more compact card
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color(.systemGray4), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2) // Very subtle shadow
        .contentShape(Rectangle())
        .animation(.snappy, value: internship.id)
    }
}

private struct WrappingChips: View {
    let items: [String]
    let horizontalSpacing: CGFloat = 8
    let verticalSpacing: CGFloat = 8

    var body: some View {
        GeometryReader { proxy in
            self.generateContent(in: proxy.size.width)
        }
        .frame(minHeight: 0)
    }

    private func chip(for text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.blue)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.blue.opacity(0.12))
                    .overlay(
                        Capsule(style: .continuous)
                            .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
    }

    private func generateContent(in availableWidth: CGFloat) -> some View {
        var currentRowWidth: CGFloat = 0
        var rows: [[String]] = [[]]

        for item in items {
            let label = UIHostingController(rootView: chip(for: item)).view!
            let fitting = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let itemWidth = fitting.width
            if currentRowWidth + itemWidth + (rows.last!.isEmpty ? 0 : horizontalSpacing) > availableWidth {
                rows.append([item])
                currentRowWidth = itemWidth
            } else {
                rows[rows.count - 1].append(item)
                currentRowWidth += itemWidth + (rows[rows.count - 1].count > 1 ? horizontalSpacing : 0)
            }
        }

        return VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(0..<rows.count, id: \.self) { row in
                HStack(spacing: horizontalSpacing) {
                    ForEach(rows[row], id: \.self) { item in
                        chip(for: item)
                    }
                }
            }
        }
    }
}


