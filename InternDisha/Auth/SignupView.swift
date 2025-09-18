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

    // Search states
    @State private var skillsSearchText: String = ""
    @State private var locationsSearchText: String = ""
    
    // Multi-step form state
    @State private var currentStep: Int = 1
    private let totalSteps: Int = 4

    let selectedRole: UserRole?
    var onSignedIn: () -> Void

    var body: some View {
        NavigationView {
        ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 8) {
                        Text(String(localized: "Create Account"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(String(localized: "Join InternDisha and start your journey"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // Progress Indicator
                        ProgressView(value: Double(currentStep), total: Double(totalSteps))
                            .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .padding(.top, 16)
                        
                        Text(String(localized: "Step %d of %d")).accessibilityLabel("Step \(currentStep) of \(totalSteps)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                    
                    // Error Message
                    if let error = auth.authError, !error.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                    Text(error)
                                .font(.caption)
                        .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 16)
                    }
                    
                    // Step Content
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 1:
                            PersonalInfoStep(
                                firstName: $firstName,
                                lastName: $lastName,
                                email: $email,
                                mobile: $mobile,
                                dob: $dob
                            )
                        case 2:
                            SecurityStep(
                                password: $password,
                                confirmPassword: $confirmPassword
                            )
                        case 3:
                            EducationAndSkillsStep(
                                qualification: $qualification,
                                selectedSkills: $selectedSkills,
                                skillsSearchText: $skillsSearchText,
                                filteredSkills: filteredSkills
                            )
                        case 4:
                            InterestAndLocationStep(
                                selectedSector: $selectedSector,
                                selectedArea: $selectedArea,
                                selectedLocations: $selectedLocations,
                                locationsSearchText: $locationsSearchText,
                                filteredLocations: filteredLocations
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 20)
                    
                    // Action Section
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            // Back Button
                            if currentStep > 1 {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStep -= 1
                                    }
                                } label: {
                                    Text(String(localized: "Back"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.accentColor)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                }
                            }
                            
                            // Next/Create Account Button
                            Button {
                                if currentStep < totalSteps {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStep += 1
                                    }
                                } else {
                                    handleCreateAccount()
                                }
                            } label: {
                                Text(currentStep == totalSteps ? String(localized: "Create Account") : String(localized: "Next"))
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(isCurrentStepValid ? Color.accentColor : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(!isCurrentStepValid)
                            .animation(.easeInOut(duration: 0.2), value: isCurrentStepValid)
                        }
                        
                        HStack(spacing: 4) {
                            Text(String(localized: "Already have an account?"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Button(String(localized: "Sign In")) {
                                onSignedIn()
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { 
            auth.authError = nil 
        }
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
            role: selectedRole ?? .student,
            skills: chosenSkills,
            interestsSector: interestSectors,
            locationPreferences: chosenLocations,
            companyName: nil,
            companyWebsite: nil,
            companyDescription: nil,
            companySize: nil,
            industry: nil,
            jobTitle: nil,
            department: nil
        )

        auth.signup(newUser: user)
        if auth.isAuthenticated { onSignedIn() }
    }
    
    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 1: // Personal Information
            return !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2: // Security
            return !password.isEmpty && password == confirmPassword
        case 3: // Education and Skills
            return true // Skills are optional
        case 4: // Interest and Location
            return true // These are optional
        default:
            return false
        }
    }
    
    private var filteredSkills: [Skill] {
        if skillsSearchText.isEmpty {
            return SkillDummy.all
        } else {
            return SkillDummy.all.filter { skill in
                skill.name.localizedCaseInsensitiveContains(skillsSearchText)
            }
        }
    }
    
    private var filteredLocations: [Location] {
        if locationsSearchText.isEmpty {
            return LocationDummy.all
        } else {
            return LocationDummy.all.filter { location in
                let searchText = locationsSearchText.lowercased()
                let state = location.state.lowercased()
                let district = location.district.lowercased()
                let city = location.city?.lowercased() ?? ""
                
                return state.contains(searchText) ||
                       district.contains(searchText) ||
                       city.contains(searchText)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Custom Components

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(LocalizedStringKey(title))
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(title))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(LocalizedStringKey(placeholder), text: $text)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(keyboardType == .emailAddress ? .emailAddress : .none)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            SecureField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .textContentType(.password)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

struct SkillToggle: View {
    let skill: Skill
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button {
            onToggle(!isSelected)
        } label: {
            HStack {
                Text(skill.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LocationToggle: View {
    let location: Location
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button {
            onToggle(!isSelected)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(location.state), \(location.district)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    if let city = location.city {
                        Text(city)
                            .font(.caption)
                            .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Step Components

struct PersonalInfoStep: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var mobile: String
    @Binding var dob: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Personal Information")
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    CustomTextField(
                        title: "First Name",
                        text: $firstName,
                        placeholder: "Enter first name"
                    )
                    
                    CustomTextField(
                        title: "Last Name",
                        text: $lastName,
                        placeholder: "Enter last name"
                    )
                }
                
                CustomTextField(
                    title: "Email Address",
                    text: $email,
                    placeholder: "name@example.com",
                    keyboardType: .emailAddress
                )
                
                CustomTextField(
                    title: "Mobile Number",
                    text: $mobile,
                    placeholder: "Enter mobile number",
                    keyboardType: .numberPad
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of Birth")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    DatePicker("", selection: $dob, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct SecurityStep: View {
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Security")
            
            VStack(spacing: 12) {
                CustomSecureField(
                    title: "Password",
                    text: $password,
                    placeholder: "Create a password"
                )
                
                CustomSecureField(
                    title: "Confirm Password",
                    text: $confirmPassword,
                    placeholder: "Confirm your password"
                )
            }
        }
    }
}

struct EducationAndSkillsStep: View {
    @Binding var qualification: Qualification
    @Binding var selectedSkills: Set<UUID>
    @Binding var skillsSearchText: String
    let filteredSkills: [Skill]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Education Section
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Education")
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Highest Qualification")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Picker("Qualification", selection: $qualification) {
                        ForEach(Qualification.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
            }
            
            // Skills Section
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Skills")
                
                // Skills Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    TextField("Search skills...", text: $skillsSearchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if !skillsSearchText.isEmpty {
                        Button {
                            skillsSearchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Skills Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(filteredSkills) { skill in
                        SkillToggle(
                            skill: skill,
                            isSelected: selectedSkills.contains(skill.id),
                            onToggle: { isSelected in
                                if isSelected {
                                    selectedSkills.insert(skill.id)
                                } else {
                                    selectedSkills.remove(skill.id)
                                }
                            }
                        )
                    }
                }
                
                if filteredSkills.isEmpty && !skillsSearchText.isEmpty {
                    Text("No skills found matching '\(skillsSearchText)'")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

struct InterestAndLocationStep: View {
    @Binding var selectedSector: Sector?
    @Binding var selectedArea: Area?
    @Binding var selectedLocations: Set<UUID>
    @Binding var locationsSearchText: String
    let filteredLocations: [Location]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Interest Section
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Areas of Interest")
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sector")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    if let areas = selectedSector?.areas {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Area")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            
            // Location Section
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Location Preferences")
                
                // Locations Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    TextField("Search locations...", text: $locationsSearchText)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    if !locationsSearchText.isEmpty {
                        Button {
                            locationsSearchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Locations List
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                    ForEach(filteredLocations) { location in
                        LocationToggle(
                            location: location,
                            isSelected: selectedLocations.contains(location.id),
                            onToggle: { isSelected in
                                if isSelected {
                                    selectedLocations.insert(location.id)
                                } else {
                                    selectedLocations.remove(location.id)
                                }
                            }
                        )
                    }
                }
                
                if filteredLocations.isEmpty && !locationsSearchText.isEmpty {
                    Text("No locations found matching '\(locationsSearchText)'")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignupView(selectedRole: .student, onSignedIn: {})
            .environmentObject(AuthViewModel())
    }
}


