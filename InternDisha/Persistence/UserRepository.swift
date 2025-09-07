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
}


