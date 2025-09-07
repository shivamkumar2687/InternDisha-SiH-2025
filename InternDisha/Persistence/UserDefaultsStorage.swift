//
//  UserDefaultsStorage.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import Foundation

protocol KeyValueStoring {
    func data(forKey: String) -> Data?
    func set(_ value: Any?, forKey: String)
    func removeObject(forKey: String)
}

extension UserDefaults: KeyValueStoring {}

struct UserDefaultsStorage {
    private let store: KeyValueStoring
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(store: KeyValueStoring = UserDefaults.standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.store = store
        self.encoder = encoder
        self.decoder = decoder
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try encoder.encode(value)
            store.set(data, forKey: key)
        } catch {
            print("[Persistence] Failed to encode value for key: \(key), error: \(error)")
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = store.data(forKey: key) else { return nil }
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("[Persistence] Failed to decode value for key: \(key), error: \(error)")
            return nil
        }
    }

    func delete(forKey key: String) {
        store.removeObject(forKey: key)
    }
}

enum PersistenceKeys {
    static let users = "persist.users"
    static let currentUser = "persist.currentUser"
    static let appliedInternships = "persist.appliedInternships"
}



