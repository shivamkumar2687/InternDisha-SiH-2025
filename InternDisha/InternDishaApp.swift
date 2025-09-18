//
//  InternDishaApp.swift
//  InternDisha
//
//  Created by Shivam Kumar on 06/09/25.
//

import SwiftUI

@main
struct InternDishaApp: App {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var localization = LocalizationController()
    @State private var needsRefresh = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .id(needsRefresh)
                .environmentObject(auth)
                .environmentObject(localization)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LanguageChanged"), object: nil)) { _ in
                    // Trigger a UI refresh when language changes
                    needsRefresh.toggle()
                }
        }
    }
}
