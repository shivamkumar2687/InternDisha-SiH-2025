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
                NavigationStack {
                    VStack(spacing: 24) {
                        NavigationLink(isActive: $showSignup) {
                            SignupView(onSignedIn: { showSignup = false })
                        } label: {
                            EmptyView()
                        }.hidden()

                        LoginView(onSignupTapped: { showSignup = true })
                    }
                    .padding()
                    .navigationTitle("Welcome")
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}


