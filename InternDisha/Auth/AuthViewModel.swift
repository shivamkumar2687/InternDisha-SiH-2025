//
//  AuthViewModel.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var authError: String?

    var isAuthenticated: Bool { currentUser != nil }
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
        self.users = repository.loadUsers()
        self.currentUser = repository.loadCurrentUser()

        if users.isEmpty {
            // Seed with a dummy user for quick login testing, then persist
            let dummyUser = User(
                id: UUID(),
                firstName: "Demo",
                lastName: "User",
                dateOfBirth: Calendar.current.date(byAdding: .year, value: -20, to: Date()) ?? Date(),
                mobile: "9999999999",
                email: "demo@intern.com",
                password: "password",
                maxQualification: .bachelors,
                skills: [SkillDummy.all.first].compactMap { $0 },
                interestsSector: [SectorDummy.all.first].compactMap { $0 },
                locationPreferences: [LocationDummy.all.first].compactMap { $0 }
            )
            users = [dummyUser]
            repository.saveUsers(users)
        }
    }

    func login(email: String, password: String) {
        authError = nil
        guard !email.isEmpty, !password.isEmpty else {
            authError = "Email and password are required."
            return
        }

        guard let user = users.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == password }) else {
            authError = "Invalid email or password."
            return
        }

        currentUser = user
        repository.saveCurrentUser(user)
    }

    func signup(newUser: User) {
        authError = nil
        if users.contains(where: { $0.email.lowercased() == newUser.email.lowercased() }) {
            authError = "An account with this email already exists."
            return
        }
        users.append(newUser)
        repository.saveUsers(users)
        currentUser = newUser
        repository.saveCurrentUser(newUser)
    }

    func logout() {
        currentUser = nil
        repository.saveCurrentUser(nil)
    }

    // Update and persist current user profile fields
    func updateCurrentUser(skills: [Skill]? = nil,
                           interests: [Sector]? = nil,
                           locations: [Location]? = nil,
                           maxQualification: Qualification? = nil) {
        guard var user = currentUser else { return }
        if let skills = skills { user.skills = skills }
        if let interests = interests { user.interestsSector = interests }
        if let locations = locations { user.locationPreferences = locations }
        if let maxQualification = maxQualification { user.maxQualification = maxQualification }
        currentUser = user
        repository.saveCurrentUser(user)
        // Also reflect in the users array
        if let idx = users.firstIndex(where: { $0.id == user.id }) {
            users[idx] = user
            repository.saveUsers(users)
        }
    }
}


