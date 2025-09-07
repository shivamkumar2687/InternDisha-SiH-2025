//
//  SignupView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var auth: AuthViewModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var mobile: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var qualification: Qualification = .bachelors

    @State private var selectedSkills: Set<UUID> = []
    @State private var selectedSector: Sector? = SectorDummy.all.first
    @State private var selectedArea: Area? = SectorDummy.all.first?.areas.first
    @State private var selectedLocations: Set<UUID> = []

    var onSignedIn: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create Account")
                    .font(.largeTitle).bold()

                if let error = auth.authError {
                    Text(error)
                        .foregroundColor(.red)
                }

                Group {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    TextField("Mobile", text: $mobile)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                }

                Picker("Qualification", selection: $qualification) {
                    ForEach(Qualification.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)
                    }
                }
                .pickerStyle(.menu)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Skills")
                        .font(.headline)
                    ForEach(SkillDummy.all) { skill in
                        Toggle(isOn: Binding(
                            get: { selectedSkills.contains(skill.id) },
                            set: { isOn in
                                if isOn { selectedSkills.insert(skill.id) } else { selectedSkills.remove(skill.id) }
                            }
                        )) {
                            Text(skill.name)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Interest")
                        .font(.headline)
                    Picker("Sector", selection: Binding(
                        get: { selectedSector?.id ?? SectorDummy.all.first!.id },
                        set: { newId in
                            selectedSector = SectorDummy.all.first(where: { $0.id == newId })
                            selectedArea = selectedSector?.areas.first
                        }
                    )) {
                        ForEach(SectorDummy.all) { sector in
                            Text(sector.name).tag(sector.id)
                        }
                    }
                    .pickerStyle(.menu)

                    if let areas = selectedSector?.areas {
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
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Location Preferences")
                        .font(.headline)
                    ForEach(LocationDummy.all) { location in
                        Toggle(isOn: Binding(
                            get: { selectedLocations.contains(location.id) },
                            set: { isOn in
                                if isOn { selectedLocations.insert(location.id) } else { selectedLocations.remove(location.id) }
                            }
                        )) {
                            Text("\(location.state), \(location.district) \(location.city ?? "")")
                        }
                    }
                }

                Button(action: handleCreateAccount) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            .padding()
        }
        .onAppear { auth.authError = nil }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleCreateAccount() {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            auth.authError = "Please enter your name."
            return
        }
        guard !mobile.isEmpty, !email.isEmpty else {
            auth.authError = "Mobile and email are required."
            return
        }
        guard !password.isEmpty, password == confirmPassword else {
            auth.authError = "Passwords do not match."
            return
        }

        let chosenSkills = SkillDummy.all.filter { selectedSkills.contains($0.id) }
        let chosenLocations = LocationDummy.all.filter { selectedLocations.contains($0.id) }
        let interestSectors: [Sector]
        if let sector = selectedSector, let area = selectedArea {
            let filteredSector = Sector(id: sector.id, name: sector.name, areas: [area])
            interestSectors = [filteredSector]
        } else if let sector = selectedSector {
            interestSectors = [sector]
        } else {
            interestSectors = []
        }

        let user = User(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dob,
            mobile: mobile,
            email: email,
            password: password,
            maxQualification: qualification,
            skills: chosenSkills,
            interestsSector: interestSectors,
            locationPreferences: chosenLocations
        )

        auth.signup(newUser: user)
        if auth.isAuthenticated { onSignedIn() }
    }
}

#Preview {
    NavigationStack {
        SignupView(onSignedIn: {})
            .environmentObject(AuthViewModel())
    }
}


