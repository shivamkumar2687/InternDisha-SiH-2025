//
//  LanguageSelectionView.swift
//  InternDisha
//
//  Created by AI Assistant on 08/09/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject private var localizationController: LocalizationController
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLanguage: String
    @State private var showRestartAlert = false
    
    init() {
        let currentLanguage = UserDefaults.standard.string(forKey: "app_language") ?? "en"
        _selectedLanguage = State(initialValue: currentLanguage)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(localizationController.getAvailableLanguages()) { language in
                    Button(action: {
                        selectedLanguage = language.code
                        showRestartAlert = true
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(language.nativeName)
                                    .font(.headline)
                                Text(language.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if language.code == localizationController.currentLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Select Language".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel".localized()) {
                        dismiss()
                    }
                }
            }
            .alert("Change Language".localized(), isPresented: $showRestartAlert) {
                Button("Cancel".localized(), role: .cancel) {
                    showRestartAlert = false
                }
                Button("Change".localized()) {
                    localizationController.changeLanguage(to: selectedLanguage)
                    dismiss()
                }
            } message: {
                Text("The app language will be changed to \(getLanguageName(for: selectedLanguage)). The app will refresh to apply changes.".localized())
            }
        }
    }
    
    private func getLanguageName(for code: String) -> String {
        if let language = localizationController.getAvailableLanguages().first(where: { $0.code == code }) {
            return language.name
        }
        return code
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(LocalizationController())
}