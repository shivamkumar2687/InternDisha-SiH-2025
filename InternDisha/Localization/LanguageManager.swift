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
    
    // Added more Indian languages: Gujarati (gu), Marathi (mr), Telugu (te), Kannada (kn), Malayalam (ml), Punjabi (pa), Odia (or)
    static let supported: [String] = ["en", "hi", "ta", "bn", "gu", "mr", "te", "kn", "ml", "pa", "or"]
    private static let persistKey = "app.selectedLanguageCode"
    
    // Language display names
    static let languageNames: [String: String] = [
        "en": "English",
        "hi": "हिन्दी (Hindi)",
        "ta": "தமிழ் (Tamil)",
        "bn": "বাংলা (Bengali)",
        "gu": "ગુજરાતી (Gujarati)",
        "mr": "मराठी (Marathi)",
        "te": "తెలుగు (Telugu)",
        "kn": "ಕನ್ನಡ (Kannada)",
        "ml": "മലയാളം (Malayalam)",
        "pa": "ਪੰਜਾਬੀ (Punjabi)",
        "or": "ଓଡ଼ିଆ (Odia)"
    ]

    init() {
        let code = UserDefaults.standard.string(forKey: Self.persistKey) ?? Locale.current.language.languageCode?.identifier ?? "en"
        let normalized = Self.supported.contains(code) ? code : "en"
        self.selectedLanguageCode = normalized
        self.locale = Locale(identifier: normalized)
    }
}


