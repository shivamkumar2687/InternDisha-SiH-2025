//
//  LoginView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var onSignupTapped: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Form Section
                VStack(spacing: 16) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(.plain)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(.plain)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
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
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Action Section
                VStack(spacing: 16) {
                    // Sign In Button
                    Button {
                        auth.login(email: email, password: password)
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isFormValid ? Color.accentColor : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!isFormValid)
                    .animation(.easeInOut(duration: 0.2), value: isFormValid)
                    
                    // Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Sign Up") {
                            onSignupTapped()
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .onTapGesture {
                focusedField = nil
            }
            .onSubmit {
                guard isFormValid else { return }
                auth.login(email: email, password: password)
            }
            .onAppear { 
                auth.authError = nil 
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }
}

#Preview {
    LoginView(onSignupTapped: {})
        .environmentObject(AuthViewModel())
        .padding()
}


