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
    
    // New methods for saved internships
    func loadSavedInternships() -> [Internship]
    func saveSavedInternships(_ internships: [Internship])
    func toggleSaveInternship(_ internship: Internship) -> Bool
    
    // Methods for getting internships by status
    func getInternshipsByStatus(_ status: InternshipStatus) -> [Internship]
    func updateInternshipStatus(_ internship: Internship, status: InternshipStatus) -> Bool
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
    
    // MARK: - Saved Internships
    
    func loadSavedInternships() -> [Internship] {
        storage.load([Internship].self, forKey: PersistenceKeys.savedInternships) ?? []
    }
    
    func saveSavedInternships(_ internships: [Internship]) {
        storage.save(internships, forKey: PersistenceKeys.savedInternships)
    }
    
    func toggleSaveInternship(_ internship: Internship) -> Bool {
        var savedInternships = loadSavedInternships()
        
        // Check if internship is already saved
        if let index = savedInternships.firstIndex(where: { $0.id == internship.id }) {
            // Remove from saved
            savedInternships.remove(at: index)
            saveSavedInternships(savedInternships)
            return false // Not saved anymore
        } else {
            // Add to saved
            var internshipToSave = internship
            internshipToSave.isSaved = true
            savedInternships.append(internshipToSave)
            saveSavedInternships(savedInternships)
            return true // Now saved
        }
    }
    
    // MARK: - Internship Status Methods
    
    func getInternshipsByStatus(_ status: InternshipStatus) -> [Internship] {
        let internships = loadAppliedInternships()
        return internships.filter { $0.status == status }
    }
    
    func updateInternshipStatus(_ internship: Internship, status: InternshipStatus) -> Bool {
        var internships = loadAppliedInternships()
        
        if let index = internships.firstIndex(where: { $0.id == internship.id }) {
            internships[index].status = status
            saveAppliedInternships(internships)
            return true
        }
        return false
    }
}



