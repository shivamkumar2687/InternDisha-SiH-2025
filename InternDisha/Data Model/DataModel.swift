//
//  DataModel.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation




// MARK: - Supporting Enums

enum Qualification: String, Codable, CaseIterable {
    case twelfth = "12th"
    case bachelors = "Bachelors"
    case masters = "Masters"
}

enum UserRole: String, Codable, CaseIterable {
    case student = "Student"
    case admin = "Admin"
    
    var displayName: String {
        return self.rawValue
    }
    
    var systemImage: String {
        switch self {
        case .student:
            return "graduationcap"
        case .admin:
            return "person.badge.key"
        }
    }
}

struct Skill: Identifiable, Codable, Hashable{
    let id: UUID
    let name: String
}

struct Interest: Identifiable, Codable{
    let id: UUID
    let name: String
}

struct Location: Identifiable, Codable, Hashable {
    let id: UUID
    var state: String
    var district: String
    var city: String? // optional, in case you want finer granularity later
}

struct Sector: Identifiable, Codable {
    let id: UUID
    let name: String
    var areas: [Area]   // Each sector contains multiple areas
}
struct Area: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
}

// A generic field-of-study representation to support diverse education streams
struct FieldOfStudy: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
}

// MARK: - User

struct User: Identifiable, Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var mobile: String
    var email: String
    var password : String?  //optional Change later
    var maxQualification: Qualification
    var role: UserRole
    
    var skills: [Skill]
    var interestsSector: [Sector]
    var locationPreferences: [Location]
    // Optional fields-of-study to cover non-BTech or varied academic backgrounds
    var fieldsOfStudy: [FieldOfStudy]? = nil
    
    // Admin/Company specific fields
    var companyName: String?
    var companyWebsite: String?
    var companyDescription: String?
    var companySize: CompanySize?
    var industry: String?
    var jobTitle: String?
    var department: String?
}

enum CompanySize: String, Codable, CaseIterable {
    case startup = "1-10 employees"
    case small = "11-50 employees"
    case medium = "51-200 employees"
    case large = "201-1000 employees"
    case enterprise = "1000+ employees"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Company

struct Company: Identifiable, Codable {
    let id: UUID
    var name: String
    var logoURL: String?
    var requiredSkills: [Skill]
    var preferredLocations: [Location]
    var minimumQualification: Qualification
}

// MARK: - Internship

enum InternshipStatus: String, Codable, CaseIterable {
    case applied = "Applied"
    case offerReceived = "Offer Received"
    case offerAccepted = "Offer Accepted"
}

struct Internship: Identifiable, Codable {
    let id: UUID
    var title: String
    var company: Company
    var sector : Sector
    var minimumQualification: Qualification
    var numberOfOpenings: Int
    var location: Location
    
    var requiredSkills: [Skill]
    // Optional acceptable fields-of-study for this internship
    var acceptedFieldsOfStudy: [FieldOfStudy]? = nil
    
    // Status for tracking application progress
    var status: InternshipStatus? = nil
    
    // Flag to track if the internship is saved by the user
    var isSaved: Bool = false
}
