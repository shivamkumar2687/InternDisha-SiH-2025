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

    var body: some View {
        Group {
            if auth.isAuthenticated {
                ContentView()
            } else {
                LoginView(onSignupTapped: { showSignup = true })
                .sheet(isPresented: $showSignup) {
                    SignupView(onSignedIn: { showSignup = false })
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}


