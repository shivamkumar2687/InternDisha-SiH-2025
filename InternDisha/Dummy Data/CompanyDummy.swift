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
        )
    ]
}
