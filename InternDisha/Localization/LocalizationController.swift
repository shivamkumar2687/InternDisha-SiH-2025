//
//  LocalizationController.swift
//  InternDisha
//
//  Created by AI Assistant on 08/09/25.
//

import SwiftUI
import Foundation
// Import notification extension

class LocalizationController: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "app_language")
            updateLocale()
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    // All supported languages
    static let supportedLanguages: [Language] = [
        Language(code: "en", name: "English", nativeName: "English"),
        Language(code: "hi", name: "Hindi", nativeName: "हिन्दी"),
        Language(code: "ta", name: "Tamil", nativeName: "தமிழ்"),
        Language(code: "bn", name: "Bengali", nativeName: "বাংলা"),
        Language(code: "gu", name: "Gujarati", nativeName: "ગુજરાતી"),
        Language(code: "mr", name: "Marathi", nativeName: "मराठी"),
        Language(code: "te", name: "Telugu", nativeName: "తెలుగు"),
        Language(code: "kn", name: "Kannada", nativeName: "ಕನ್ನಡ"),
        Language(code: "ml", name: "Malayalam", nativeName: "മലയാളം"),
        Language(code: "pa", name: "Punjabi", nativeName: "ਪੰਜਾਬੀ"),
        Language(code: "or", name: "Odia", nativeName: "ଓଡ଼ିଆ")
    ]
    
    private var locale: Locale = .current
    
    init() {
        // Get saved language or use device language
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language")
        let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        // Use saved language if available, otherwise check if device language is supported
        if let savedLanguage = savedLanguage, LocalizationController.isLanguageSupported(savedLanguage) {
            self.currentLanguage = savedLanguage
        } else if LocalizationController.isLanguageSupported(deviceLanguage) {
            self.currentLanguage = deviceLanguage
        } else {
            self.currentLanguage = "en" // Default to English
        }
        
        updateLocale()
    }
    
    // Check if a language is supported
    private static func isLanguageSupported(_ code: String) -> Bool {
        return LocalizationController.supportedLanguages.contains { $0.code == code }
    }
    
    // Update the locale based on the current language
    private func updateLocale() {
        self.locale = Locale(identifier: currentLanguage)
        
        // Force update the app's language
        UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    // Change language and restart the app
    func changeLanguage(to languageCode: String) {
        guard LocalizationController.isLanguageSupported(languageCode) else { return }
        
        currentLanguage = languageCode
        
        // This will trigger a UI refresh through the didSet property observer
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    // Get the current language object
    func getCurrentLanguage() -> Language {
        return LocalizationController.supportedLanguages.first { $0.code == currentLanguage } ?? 
               LocalizationController.supportedLanguages.first!
    }
    
    // Get all available languages
    func getAvailableLanguages() -> [Language] {
        return LocalizationController.supportedLanguages
    }
}

// Language model
struct Language: Identifiable, Equatable {
    var id: String { code }
    let code: String
    let name: String
    let nativeName: String
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code
    }
}

// Extension to get localized string
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
