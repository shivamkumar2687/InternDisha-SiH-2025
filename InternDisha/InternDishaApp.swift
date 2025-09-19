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
    @StateObject private var language = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
                .environmentObject(language)
        }
    }
}
