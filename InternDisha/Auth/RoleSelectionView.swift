//
//  RoleSelectionView.swift
//  InternDisha
//
//  Created by AI Assistant on 17/09/25.
//

import SwiftUI

struct RoleSelectionView: View {
    @Binding var selectedRole: UserRole?
    let onRoleSelected: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "person.2.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Choose Your Role")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Select how you want to use InternDisha")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Role Selection Cards
                VStack(spacing: 20) {
                    ForEach(UserRole.allCases, id: \.self) { role in
                        RoleCard(
                            role: role,
                            isSelected: selectedRole == role,
                            onTap: {
                                selectedRole = role
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Continue Button
                Button(action: onRoleSelected) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedRole != nil ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(selectedRole == nil)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct RoleCard: View {
    let role: UserRole
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Role Icon
                Image(systemName: role.systemImage)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                
                // Role Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(role.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(roleDescription(for: role))
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(20)
            .background(isSelected ? Color.blue : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func roleDescription(for role: UserRole) -> String {
        switch role {
        case .student:
            return "Find and apply for internships that match your skills and interests"
        case .admin:
            return "Manage internship listings, review applications, and oversee the platform"
        }
    }
}

#Preview {
    RoleSelectionView(selectedRole: .constant(nil)) {
        print("Role selected")
    }
}




