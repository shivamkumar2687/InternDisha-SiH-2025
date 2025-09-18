//
//  AdminSignupView.swift
//  InternDisha
//
//  Created by AI Assistant on 17/09/25.
//

import SwiftUI

struct AdminSignupView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var mobile: String = ""
    
    // Company/Organization fields
    @State private var companyName: String = ""
    @State private var companyWebsite: String = ""
    @State private var companyDescription: String = ""
    @State private var companySize: CompanySize = .medium
    @State private var industry: String = ""
    @State private var jobTitle: String = ""
    @State private var department: String = ""
    
    // Multi-step form state
    @State private var currentStep: Int = 1
    private let totalSteps: Int = 3
    
    var onSignedIn: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.badge.key")
                                .foregroundColor(.blue)
                            Text("Company Registration")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Text("Join as an organization to post internships and manage applications")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                    
                    // Progress Indicator
                    ProgressView(value: Double(currentStep), total: Double(totalSteps))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.horizontal, 32)
                        .padding(.bottom, 30)
                    
                    // Form Content
                    VStack(spacing: 24) {
                        if currentStep == 1 {
                            AdminPersonalInfoStep(
                                firstName: $firstName,
                                lastName: $lastName,
                                email: $email,
                                mobile: $mobile
                            )
                        } else if currentStep == 2 {
                            CompanyInfoStep(
                                companyName: $companyName,
                                companyWebsite: $companyWebsite,
                                companyDescription: $companyDescription,
                                companySize: $companySize,
                                industry: $industry
                            )
                        } else if currentStep == 3 {
                            JobInfoStep(
                                jobTitle: $jobTitle,
                                department: $department,
                                password: $password,
                                confirmPassword: $confirmPassword
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Navigation Buttons
                    VStack(spacing: 16) {
                        if currentStep > 1 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep -= 1
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Button(currentStep == totalSteps ? "Create Account" : "Continue") {
                            if currentStep == totalSteps {
                                signup()
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep += 1
                                }
                            }
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isCurrentStepValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                        .disabled(!isCurrentStepValid)
                        .animation(.easeInOut(duration: 0.2), value: isCurrentStepValid)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                auth.authError = nil
            }
        }
    }
    
    private func signup() {
        let user = User(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
            mobile: mobile,
            email: email,
            password: password,
            maxQualification: .masters, // Default for admin
            role: .admin,
            skills: [],
            interestsSector: [],
            locationPreferences: [],
            companyName: companyName,
            companyWebsite: companyWebsite,
            companyDescription: companyDescription,
            companySize: companySize,
            industry: industry,
            jobTitle: jobTitle,
            department: department
        )
        
        auth.signup(newUser: user)
        if auth.isAuthenticated {
            onSignedIn()
        }
    }
    
    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 1:
            return !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            return !companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !industry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 3:
            return !jobTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !password.isEmpty &&
                   password == confirmPassword
        default:
            return false
        }
    }
}

// MARK: - Step Views

struct AdminPersonalInfoStep: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var mobile: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Personal Information")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter first name", text: $firstName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter last name", text: $lastName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("Enter email address", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mobile Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("Enter mobile number", text: $mobile)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.phonePad)
                }
            }
        }
    }
}

struct CompanyInfoStep: View {
    @Binding var companyName: String
    @Binding var companyWebsite: String
    @Binding var companyDescription: String
    @Binding var companySize: CompanySize
    @Binding var industry: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Company Information")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Company Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("Enter company name", text: $companyName)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Industry")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("e.g., Technology, Healthcare, Finance", text: $industry)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Company Size")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Picker("Company Size", selection: $companySize) {
                        ForEach(CompanySize.allCases, id: \.self) { size in
                            Text(size.displayName).tag(size)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Company Website (Optional)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("https://www.company.com", text: $companyWebsite)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Company Description (Optional)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("Brief description of your company", text: $companyDescription, axis: .vertical)
                        .textFieldStyle(CustomTextFieldStyle())
                        .lineLimit(3...6)
                }
            }
        }
    }
}

struct JobInfoStep: View {
    @Binding var jobTitle: String
    @Binding var department: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Job Information & Security")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Job Title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("e.g., HR Manager, Recruiter, CEO", text: $jobTitle)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Department")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    TextField("e.g., Human Resources, Engineering", text: $department)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    SecureField("Create a password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    SecureField("Confirm your password", text: $confirmPassword)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                if !password.isEmpty && password != confirmPassword {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        Text("Passwords do not match")
                            .font(.caption)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

#Preview {
    AdminSignupView(onSignedIn: {})
        .environmentObject(AuthViewModel())
}
