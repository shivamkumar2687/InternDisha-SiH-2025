//
//  RootView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showSignup = false
    @State private var selectedRole: UserRole?
    @State private var showLogin = false

    var body: some View {
        Group {
            if auth.isAuthenticated {
                // Show different content based on user role
                if auth.currentUser?.role == .admin {
                    AdminContentView()
                } else {
                    ContentView()
                }
            } else if showLogin {
                LoginView(
                    selectedRole: selectedRole,
                    onSignupTapped: { showSignup = true },
                    onBackTapped: { 
                        showLogin = false
                        selectedRole = nil
                    }
                )
                .sheet(isPresented: $showSignup) {
                    if selectedRole == .admin {
                        AdminSignupView(onSignedIn: { showSignup = false })
                    } else {
                        SignupView(
                            selectedRole: selectedRole,
                            onSignedIn: { showSignup = false }
                        )
                    }
                }
            } else {
                RoleSelectionView(selectedRole: $selectedRole) {
                    showLogin = true
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}


