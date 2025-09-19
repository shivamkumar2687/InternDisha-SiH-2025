//
//  LanguageManager.swift
//  InternDisha
//
//  Created by AI Assistant on 08/09/25.
//

import SwiftUI

final class LanguageManager: ObservableObject {
    @Published var selectedLanguageCode: String {
        didSet {
            UserDefaults.standard.set(selectedLanguageCode, forKey: Self.persistKey)
            locale = Locale(identifier: selectedLanguageCode)
        }
    }

    @Published var locale: Locale

    static let supported: [String] = ["en", "hi", "ta", "bn"]
    private static let persistKey = "app.selectedLanguageCode"

    init() {
        let code = UserDefaults.standard.string(forKey: Self.persistKey) ?? Locale.current.language.languageCode?.identifier ?? "en"
        let normalized = Self.supported.contains(code) ? code : "en"
        self.selectedLanguageCode = normalized
        self.locale = Locale(identifier: normalized)
    }
}


