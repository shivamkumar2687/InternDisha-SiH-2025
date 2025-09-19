//
//  CompanyDummy.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation


struct CompanyDummy {
    static let all: [Company] = [
        Company(
            id: UUID(),
            name: "TechCorp",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[0], LocationDummy.all[1]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "FinServe",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[2]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "DesignHub",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[3]],
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "InnovateTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]],
            preferredLocations: [LocationDummy.all[4], LocationDummy.all[5]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "DataMinds",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[6]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "CloudNine",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[7], LocationDummy.all[8]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "QuantumLeap",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[9]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "PixelPerfect",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[10]],
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "CodeCrafters",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]],
            preferredLocations: [LocationDummy.all[11], LocationDummy.all[12]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "FinancialForce",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[13]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "HealthTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[14], LocationDummy.all[15]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "EduLearn",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[16]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "GreenEnergy",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[17], LocationDummy.all[18]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "TravelTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]],
            preferredLocations: [LocationDummy.all[19]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "RetailPlus",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[3], SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[20], LocationDummy.all[21]],
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "MediaMasters",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[22]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "FoodTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[23], LocationDummy.all[24]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "SmartHome",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[1], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[25]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "SecuritySolutions",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[2]],
            preferredLocations: [LocationDummy.all[26], LocationDummy.all[27]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "AgriTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[28]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "SpaceTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[29]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "AutomationPro",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]],
            preferredLocations: [LocationDummy.all[0], LocationDummy.all[5]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "BlockchainTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[2]],
            preferredLocations: [LocationDummy.all[6], LocationDummy.all[10]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "AIInnovate",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]],
            preferredLocations: [LocationDummy.all[15], LocationDummy.all[20]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "GameDev",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[5]],
            preferredLocations: [LocationDummy.all[22], LocationDummy.all[25]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "EcomSolutions",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[7], LocationDummy.all[14]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "CloudComputing",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[2]],
            preferredLocations: [LocationDummy.all[9], LocationDummy.all[18]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "MobileTech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]],
            preferredLocations: [LocationDummy.all[11], LocationDummy.all[21]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "DataAnalytics",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]],
            preferredLocations: [LocationDummy.all[13], LocationDummy.all[23]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "CyberSecurity",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[2]],
            preferredLocations: [LocationDummy.all[16], LocationDummy.all[26]],
            minimumQualification: .masters
        )
    ]
}
