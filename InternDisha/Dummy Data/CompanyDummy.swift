//
//  CompanyDummy.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation


struct CompanyDummy {
//    static let all: [Company] = [
//        Company(
//            id: UUID(),
//            name: "TechCorp",
//            logoURL: nil,
//            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]],
//            preferredLocations: [LocationDummy.all[0], LocationDummy.all[1]],
//            minimumQualification: .bachelors
//        ),
//        Company(
//            id: UUID(),
//            name: "FinServe",
//            logoURL: nil,
//            requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]],
//            preferredLocations: [LocationDummy.all[2]],
//            minimumQualification: .masters
//        ),
//        Company(
//            id: UUID(),
//            name: "DesignHub",
//            logoURL: nil,
//            requiredSkills: [SkillDummy.all[5]],
//            preferredLocations: [LocationDummy.all[3]],
//            minimumQualification: .twelfth
//        )
//    ]
    static let all: [Company] = [
        Company(
            id: UUID(),
            name: "TechCorp",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]], // Swift, SQL
            preferredLocations: [LocationDummy.all[0], LocationDummy.all[1]], // Pune, Noida
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "FinServe",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[11], SkillDummy.all[12]], // Financial Modeling, Data Analysis
            preferredLocations: [LocationDummy.all[3], LocationDummy.all[6]], // Delhi, Ahmedabad
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "DesignPro",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[5], SkillDummy.all[14]], // UI/UX Design, Illustrator
            preferredLocations: [LocationDummy.all[4], LocationDummy.all[7]], // Chennai, Mumbai
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "Cloudify",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[15], SkillDummy.all[16]], // Docker, AWS
            preferredLocations: [LocationDummy.all[2], LocationDummy.all[8]], // Bangalore, Chandigarh
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "MarketEdge",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[19], SkillDummy.all[18]], // Digital Marketing, Cybersecurity
            preferredLocations: [LocationDummy.all[9], LocationDummy.all[10]], // Gurgaon, Jaipur
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "AppVantage",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[1], SkillDummy.all[7]], // Kotlin, React
            preferredLocations: [LocationDummy.all[0], LocationDummy.all[2]], // Pune, Bangalore
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "DataPulse",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[12]], // Python, Data Analysis
            preferredLocations: [LocationDummy.all[11], LocationDummy.all[13]], // Kochi, Bhubaneswar
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "Creative Minds",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[14], SkillDummy.all[13]], // Illustrator, Photoshop
            preferredLocations: [LocationDummy.all[14], LocationDummy.all[15]], // Indore, Guwahati
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "SecureNet",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[18]], // Cybersecurity
            preferredLocations: [LocationDummy.all[16], LocationDummy.all[17]], // Raipur, Ranchi
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "NextGen Solutions",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[8], SkillDummy.all[9]], // Java, C++
            preferredLocations: [LocationDummy.all[18], LocationDummy.all[19]], // Patna, Dehradun
            minimumQualification: .bachelors
        ),
        // 10 more companies with different combinations
        Company(
            id: UUID(),
            name: "BlueWave Tech",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[0], SkillDummy.all[7]], // Swift, React
            preferredLocations: [LocationDummy.all[1], LocationDummy.all[3]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "EcoFinance",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[11], SkillDummy.all[12]],
            preferredLocations: [LocationDummy.all[5], LocationDummy.all[6]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "PixelPerfect",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[5], SkillDummy.all[13]],
            preferredLocations: [LocationDummy.all[7], LocationDummy.all[9]],
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "CloudNet",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[15], SkillDummy.all[16]],
            preferredLocations: [LocationDummy.all[2], LocationDummy.all[8]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "BrightIdeas",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[19], SkillDummy.all[18]],
            preferredLocations: [LocationDummy.all[10], LocationDummy.all[11]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "AppMasters",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[1], SkillDummy.all[7]],
            preferredLocations: [LocationDummy.all[4], LocationDummy.all[5]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "DataStream",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[2], SkillDummy.all[12]],
            preferredLocations: [LocationDummy.all[14], LocationDummy.all[13]],
            minimumQualification: .masters
        ),
        Company(
            id: UUID(),
            name: "CreativeX",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[14], SkillDummy.all[13]],
            preferredLocations: [LocationDummy.all[15], LocationDummy.all[16]],
            minimumQualification: .twelfth
        ),
        Company(
            id: UUID(),
            name: "CyberGuard",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[18]],
            preferredLocations: [LocationDummy.all[17], LocationDummy.all[19]],
            minimumQualification: .bachelors
        ),
        Company(
            id: UUID(),
            name: "TechAdvance",
            logoURL: nil,
            requiredSkills: [SkillDummy.all[8], SkillDummy.all[9]],
            preferredLocations: [LocationDummy.all[0], LocationDummy.all[1]],
            minimumQualification: .bachelors
        )
    ]

}
