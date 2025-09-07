//
//  ProfileView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if let user = auth.currentUser {
                Form {
                    Section(header: Text("Personal Information")) {
                        HStack { Text("Name"); Spacer(); Text("\(user.firstName) \(user.lastName)").foregroundColor(.secondary) }
                        HStack { Text("Date of Birth"); Spacer(); Text(formatted(date: user.dateOfBirth)).foregroundColor(.secondary) }
                        HStack { Text("Mobile"); Spacer(); Text(user.mobile).foregroundColor(.secondary) }
                        HStack { Text("Email"); Spacer(); Text(user.email).foregroundColor(.secondary) }
                        HStack { Text("Qualification"); Spacer(); Text(user.maxQualification.rawValue).foregroundColor(.secondary) }
                    }

                    Section(header: Text("Skills")) {
                        if user.skills.isEmpty {
                            Text("No skills selected").foregroundColor(.secondary)
                        } else {
                            ForEach(user.skills) { skill in
                                Text(skill.name)
                            }
                        }
                    }

                    Section(header: Text("Interests")) {
                        if user.interestsSector.isEmpty {
                            Text("No interests selected").foregroundColor(.secondary)
                        } else {
                            ForEach(user.interestsSector) { sector in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sector.name).font(.headline)
                                    if sector.areas.isEmpty == false {
                                        Text(sector.areas.map { $0.name }.joined(separator: ", "))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    Section(header: Text("Location Preferences")) {
                        if user.locationPreferences.isEmpty {
                            Text("No locations selected").foregroundColor(.secondary)
                        } else {
                            ForEach(user.locationPreferences) { loc in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(loc.state), \(loc.district)")
                                    if let city = loc.city, city.isEmpty == false {
                                        Text(city).foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    Section {
                        Button(role: .destructive) {
                            auth.logout()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Logout")
                                Spacer()
                            }
                        }
                    }
                }
                .navigationTitle("Profile")
            } else {
                VStack(spacing: 12) {
                    Text("Not logged in")
                    Text("Please sign in to view your profile.")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    ProfileView()
}
