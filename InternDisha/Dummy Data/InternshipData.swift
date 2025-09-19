//
//  InternshipData.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation


struct InternshipDummy {
    static let all: [Internship] = [
        // Original internships
        Internship(id: UUID(), title: "iOS Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Android Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[1], requiredSkills: [SkillDummy.all[1]]),
        
        Internship(id: UUID(), title: "Data Science Intern", company: CompanyDummy.all[1], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 4, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "ML Research Intern", company: CompanyDummy.all[1], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Finance Analyst Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 5, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Accounting Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Investment Banking Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2]]),
        
        Internship(id: UUID(), title: "UI/UX Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 2, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Graphic Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 1, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Web Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[4], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "SQL Database Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[3]]),
        
        // New internships
        Internship(id: UUID(), title: "Frontend Developer Intern", company: CompanyDummy.all[3], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 4, location: LocationDummy.all[5], requiredSkills: [SkillDummy.all[6], SkillDummy.all[7]]),
        
        Internship(id: UUID(), title: "Backend Developer Intern", company: CompanyDummy.all[3], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[5], requiredSkills: [SkillDummy.all[8], SkillDummy.all[2]]),
        
        Internship(id: UUID(), title: "Data Analyst Intern", company: CompanyDummy.all[4], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[6], requiredSkills: [SkillDummy.all[2], SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "AI Research Intern", company: CompanyDummy.all[4], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[6], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Cloud Engineer Intern", company: CompanyDummy.all[5], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[7], requiredSkills: [SkillDummy.all[12], SkillDummy.all[13]]),
        
        Internship(id: UUID(), title: "DevOps Intern", company: CompanyDummy.all[5], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[8], requiredSkills: [SkillDummy.all[13]]),
        
        Internship(id: UUID(), title: "Blockchain Developer Intern", company: CompanyDummy.all[6], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[9], requiredSkills: [SkillDummy.all[14]]),
        
        Internship(id: UUID(), title: "Cybersecurity Intern", company: CompanyDummy.all[6], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[9], requiredSkills: [SkillDummy.all[15]]),
        
        Internship(id: UUID(), title: "UI Designer Intern", company: CompanyDummy.all[7], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 3, location: LocationDummy.all[10], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Digital Marketing Intern", company: CompanyDummy.all[8], sector: SectorDummy.marketing, minimumQualification: .bachelors, numberOfOpenings: 4, location: LocationDummy.all[11], requiredSkills: [SkillDummy.all[16]]),
        
        Internship(id: UUID(), title: "Content Writing Intern", company: CompanyDummy.all[8], sector: SectorDummy.marketing, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[12], requiredSkills: [SkillDummy.all[17]]),
        
        Internship(id: UUID(), title: "Financial Analyst Intern", company: CompanyDummy.all[9], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[13], requiredSkills: [SkillDummy.all[3], SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "Healthcare Data Analyst Intern", company: CompanyDummy.all[10], sector: SectorDummy.healthcare, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[14], requiredSkills: [SkillDummy.all[2], SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "Medical Research Intern", company: CompanyDummy.all[10], sector: SectorDummy.healthcare, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[15], requiredSkills: [SkillDummy.all[2]]),
        
        Internship(id: UUID(), title: "EdTech Developer Intern", company: CompanyDummy.all[11], sector: SectorDummy.education, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[16], requiredSkills: [SkillDummy.all[0], SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Renewable Energy Analyst Intern", company: CompanyDummy.all[12], sector: SectorDummy.energy, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[17], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Travel App Developer Intern", company: CompanyDummy.all[13], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[19], requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]]),
        
        Internship(id: UUID(), title: "E-commerce Intern", company: CompanyDummy.all[14], sector: SectorDummy.retail, minimumQualification: .twelfth, numberOfOpenings: 4, location: LocationDummy.all[20], requiredSkills: [SkillDummy.all[3], SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Media Production Intern", company: CompanyDummy.all[15], sector: SectorDummy.media, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[22], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Food Delivery App Intern", company: CompanyDummy.all[16], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[23], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "IoT Developer Intern", company: CompanyDummy.all[17], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[25], requiredSkills: [SkillDummy.all[1], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Security Analyst Intern", company: CompanyDummy.all[18], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[26], requiredSkills: [SkillDummy.all[0], SkillDummy.all[2]]),
        
        Internship(id: UUID(), title: "Agricultural Data Analyst Intern", company: CompanyDummy.all[19], sector: SectorDummy.agriculture, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[28], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Aerospace Engineer Intern", company: CompanyDummy.all[20], sector: SectorDummy.engineering, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[29], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Automation Engineer Intern", company: CompanyDummy.all[21], sector: SectorDummy.engineering, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]]),
        
        Internship(id: UUID(), title: "Blockchain Researcher Intern", company: CompanyDummy.all[22], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[6], requiredSkills: [SkillDummy.all[0], SkillDummy.all[14]]),
        
        Internship(id: UUID(), title: "AI Product Manager Intern", company: CompanyDummy.all[23], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[15], requiredSkills: [SkillDummy.all[4], SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Game Developer Intern", company: CompanyDummy.all[24], sector: SectorDummy.entertainment, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[22], requiredSkills: [SkillDummy.all[0], SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "E-commerce Developer Intern", company: CompanyDummy.all[25], sector: SectorDummy.retail, minimumQualification: .bachelors, numberOfOpenings: 4, location: LocationDummy.all[7], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Cloud Solutions Intern", company: CompanyDummy.all[26], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[9], requiredSkills: [SkillDummy.all[0], SkillDummy.all[12]]),
        
        Internship(id: UUID(), title: "Mobile App Developer Intern", company: CompanyDummy.all[27], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[11], requiredSkills: [SkillDummy.all[0], SkillDummy.all[1]]),
        
        Internship(id: UUID(), title: "Business Analytics Intern", company: CompanyDummy.all[28], sector: SectorDummy.consulting, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[13], requiredSkills: [SkillDummy.all[2], SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "Network Security Intern", company: CompanyDummy.all[29], sector: SectorDummy.telecommunications, minimumQualification: .masters, numberOfOpenings: 1, location: LocationDummy.all[16], requiredSkills: [SkillDummy.all[15]]),
        
        Internship(id: UUID(), title: "React Developer Intern", company: CompanyDummy.all[3], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[18], requiredSkills: [SkillDummy.all[6], SkillDummy.all[7]]),
        
        Internship(id: UUID(), title: "Node.js Developer Intern", company: CompanyDummy.all[5], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[20], requiredSkills: [SkillDummy.all[6], SkillDummy.all[8]]),
        
        Internship(id: UUID(), title: "Java Developer Intern", company: CompanyDummy.all[8], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[21], requiredSkills: [SkillDummy.all[9]]),
        
        Internship(id: UUID(), title: "C++ Developer Intern", company: CompanyDummy.all[12], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[24], requiredSkills: [SkillDummy.all[10]]),
        
        Internship(id: UUID(), title: "Project Management Intern", company: CompanyDummy.all[15], sector: SectorDummy.consulting, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[27], requiredSkills: [SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Digital Marketing Strategist Intern", company: CompanyDummy.all[14], sector: SectorDummy.marketing, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[1], requiredSkills: [SkillDummy.all[16], SkillDummy.all[17]]),
        
        Internship(id: UUID(), title: "Graphic Design Specialist Intern", company: CompanyDummy.all[7], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 3, location: LocationDummy.all[4], requiredSkills: [SkillDummy.all[18]]),
        
        Internship(id: UUID(), title: "Content Creator Intern", company: CompanyDummy.all[15], sector: SectorDummy.media, minimumQualification: .bachelors, numberOfOpenings: 4, location: LocationDummy.all[8], requiredSkills: [SkillDummy.all[17], SkillDummy.all[18]]),
        
        Internship(id: UUID(), title: "Supply Chain Analyst Intern", company: CompanyDummy.all[14], sector: SectorDummy.logistics, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[12], requiredSkills: [SkillDummy.all[11], SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Legal Research Intern", company: CompanyDummy.all[18], sector: SectorDummy.legal, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[17], requiredSkills: [SkillDummy.all[17]]),
        
        Internship(id: UUID(), title: "Hospitality Management Intern", company: CompanyDummy.all[13], sector: SectorDummy.hospitality, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[19], requiredSkills: [SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Real Estate Analyst Intern", company: CompanyDummy.all[19], sector: SectorDummy.realestate, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[23], requiredSkills: [SkillDummy.all[3], SkillDummy.all[11]])
    ]
}
