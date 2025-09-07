//
//  UserRepository.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func loadUsers() -> [User]
    func saveUsers(_ users: [User])
    func loadCurrentUser() -> User?
    func saveCurrentUser(_ user: User?)
    func loadAppliedInternships() -> [Internship]
    func saveAppliedInternships(_ internships: [Internship])
    func addAppliedInternship(_ internship: Internship)
    func removeAppliedInternship(_ internship: Internship) -> Bool
}

struct UserRepository: UserRepositoryProtocol {
    private let storage: UserDefaultsStorage

    init(storage: UserDefaultsStorage = UserDefaultsStorage()) {
        self.storage = storage
    }

    func loadUsers() -> [User] {
        storage.load([User].self, forKey: PersistenceKeys.users) ?? []
    }

    func saveUsers(_ users: [User]) {
        storage.save(users, forKey: PersistenceKeys.users)
    }

    func loadCurrentUser() -> User? {
        storage.load(User.self, forKey: PersistenceKeys.currentUser)
    }

    func saveCurrentUser(_ user: User?) {
        if let user = user {
            storage.save(user, forKey: PersistenceKeys.currentUser)
        } else {
            storage.delete(forKey: PersistenceKeys.currentUser)
        }
    }
    
    func loadAppliedInternships() -> [Internship] {
        storage.load([Internship].self, forKey: PersistenceKeys.appliedInternships) ?? []
    }
    
    func saveAppliedInternships(_ internships: [Internship]) {
        storage.save(internships, forKey: PersistenceKeys.appliedInternships)
    }
    
    func addAppliedInternship(_ internship: Internship) {
        var internships = loadAppliedInternships()
        // Check if internship already exists to avoid duplicates
        if !internships.contains(where: { $0.id == internship.id }) {
            internships.append(internship)
            saveAppliedInternships(internships)
        }
    }
    
    func removeAppliedInternship(_ internship: Internship) -> Bool {
        var internships = loadAppliedInternships()
        if let index = internships.firstIndex(where: { $0.id == internship.id }) {
            internships.remove(at: index)
            saveAppliedInternships(internships)
            return true
        }
        return false
    }
}



