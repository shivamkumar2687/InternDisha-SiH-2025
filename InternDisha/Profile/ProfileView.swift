//
//  ProfileView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var language: LanguageManager
    @State private var showEdit = false

    var body: some View {
        Group {
            if let user = auth.currentUser {
                Form {
                    Section {
                        VStack(spacing: 16) {
                            // Profile Icon
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                            
                            // User Name
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            // User Email
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                    
                    Section(header: Text(String(localized: "Personal Information"))) {
                        HStack { Text(String(localized: "Name")); Spacer(); Text("\(user.firstName) \(user.lastName)").foregroundColor(.secondary) }
                        HStack { Text(String(localized: "Date of Birth")); Spacer(); Text(formatted(date: user.dateOfBirth)).foregroundColor(.secondary) }
                        HStack { Text(String(localized: "Mobile")); Spacer(); Text(user.mobile).foregroundColor(.secondary) }
                        HStack { Text(String(localized: "Email")); Spacer(); Text(user.email).foregroundColor(.secondary) }
                        HStack { Text(String(localized: "Qualification")); Spacer(); Text(LocalizedStringKey(user.maxQualification.rawValue)).foregroundColor(.secondary) }
                    }

                    Section(header: Text(String(localized: "Skills"))) {
                        if user.skills.isEmpty {
                            Text(String(localized: "No skills selected")).foregroundColor(.secondary)
                        } else {
                            ForEach(user.skills) { skill in
                                Text(skill.name)
                            }
                        }
                    }

                    Section(header: Text(String(localized: "Interests"))) {
                        if user.interestsSector.isEmpty {
                            Text(String(localized: "No interests selected")).foregroundColor(.secondary)
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

                    Section(header: Text(String(localized: "Location Preferences"))) {
                        if user.locationPreferences.isEmpty {
                            Text(String(localized: "No locations selected")).foregroundColor(.secondary)
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

                    Section(header: Text(String(localized: "Language"))) {
                        Picker(String(localized: "App Language"), selection: $language.selectedLanguageCode) {
                            Text("English").tag("en")
                            Text("हिन्दी").tag("hi")
                            Text("தமிழ்").tag("ta")
                            Text("বাংলা").tag("bn")
                        }
                        .pickerStyle(.menu)
                    }

                    Section {
                        Button(role: .destructive) {
                            auth.logout()
                        } label: {
                            HStack {
                                Spacer()
                                Text(String(localized: "Logout"))
                                Spacer()
                            }
                        }
                    }
                }
                .id(language.selectedLanguageCode)
                .environment(\.locale, language.locale)
                .navigationTitle(String(localized: "Profile"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(String(localized: "Edit")) { showEdit = true }
                    }
                }
                .sheet(isPresented: $showEdit) {
                    EditProfileSheet(
                        initialUser: user,
                        onSave: { updated in
                            auth.updateCurrentUser(
                                skills: updated.skills,
                                interests: updated.interestsSector,
                                locations: updated.locationPreferences,
                                maxQualification: updated.maxQualification
                            )
                        }
                    )
                }
            } else {
                VStack(spacing: 12) {
                    Text(String(localized: "Not logged in"))
                    Text(String(localized: "Please sign in to view your profile."))
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
