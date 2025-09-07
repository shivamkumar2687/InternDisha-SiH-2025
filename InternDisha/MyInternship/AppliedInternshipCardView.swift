//
//  AppliedInternshipCardView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import SwiftUI

struct AppliedInternshipCardView: View {
    let internship: Internship
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Company and location
            HStack {
                Text(internship.company.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text(internship.location.city ?? internship.location.district)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Internship title
            Text(internship.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 2)
            
            // Key details in key-value format
            HStack {
                Text("ID")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(internship.id.uuidString.prefix(8).uppercased())
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
            }
            .padding(.vertical, 4)
            
            HStack {
                Text("Qualification")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(internship.minimumQualification.rawValue)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
            }
            
            HStack {
                Text("Openings")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(internship.numberOfOpenings)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
            }
            
            HStack {
                Text("Area")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(internship.sector.areas.first?.name ?? "")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
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
                // Status badge based on internship status
                statusBadge
                
                Spacer()
  
                Button(action: {}) {
                    Text("Apply")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.blue)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .cornerRadius(8)
                
                Button(action: {}) {
                    Text("About")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.blue)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .cornerRadius(8)
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
    
    private var statusBadge: some View {
        Group {
            switch internship.status {
            case .offerReceived:
                Text("Offer Received")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
            case .offerAccepted:
                Text("Offer Accepted")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.purple))
            default:
                Text("Applied")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
            }
        }
    }
}

#Preview {
    AppliedInternshipCardView(internship: InternshipDummy.all[0])
}
