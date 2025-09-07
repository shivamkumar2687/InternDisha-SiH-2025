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
        VStack(alignment: .leading, spacing: 16) {
            Text("Login")
                .font(.largeTitle).bold()

            if let error = auth.authError {
                Text(error)
                    .foregroundColor(.red)
            }

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .email)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .password)

            Button(action: {
                auth.login(email: email, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            HStack {
                Text("Don't have an account?")
                Button("Sign up") { onSignupTapped() }
            }
            .font(.subheadline)
            .padding(.top, 8)
        }
        .onAppear { auth.authError = nil }
    }
}

#Preview {
    LoginView(onSignupTapped: {})
        .environmentObject(AuthViewModel())
        .padding()
}


