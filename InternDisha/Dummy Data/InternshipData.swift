//
//  InternshipData.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation


struct InternshipDummy {
//    static let all: [Internship] = [
//        Internship(id: UUID(), title: "iOS Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
//        
//        Internship(id: UUID(), title: "Android Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[1], requiredSkills: [SkillDummy.all[1]]),
//        
//        Internship(id: UUID(), title: "Data Science Intern", company: CompanyDummy.all[1], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 4, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]]),
//        
//        Internship(id: UUID(), title: "ML Research Intern", company: CompanyDummy.all[1], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
//        
//        Internship(id: UUID(), title: "Finance Analyst Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 5, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[3]]),
//        
//        Internship(id: UUID(), title: "Accounting Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[3]]),
//        
//        Internship(id: UUID(), title: "Investment Banking Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2]]),
//        
//        Internship(id: UUID(), title: "UI/UX Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 2, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[5]]),
//        
//        Internship(id: UUID(), title: "Graphic Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 1, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[5]]),
//        
//        Internship(id: UUID(), title: "Web Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[4], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
//        
//        Internship(id: UUID(), title: "SQL Database Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[3]])
//    ]
    static let all: [Internship] = [
        Internship(id: UUID(), title: "iOS Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[0], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Android Developer Intern", company: CompanyDummy.all[5], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[1], requiredSkills: [SkillDummy.all[1]]),
        
        Internship(id: UUID(), title: "Data Science Intern", company: CompanyDummy.all[6], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 4, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "ML Research Intern", company: CompanyDummy.all[6], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[2], SkillDummy.all[4]]),
        
        Internship(id: UUID(), title: "Finance Analyst Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 5, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "Accounting Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[3], requiredSkills: [SkillDummy.all[11]]),
        
        Internship(id: UUID(), title: "Investment Banking Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[2], requiredSkills: [SkillDummy.all[12]]),
        
        Internship(id: UUID(), title: "UI/UX Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 2, location: LocationDummy.all[4], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "Graphic Design Intern", company: CompanyDummy.all[7], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 1, location: LocationDummy.all[4], requiredSkills: [SkillDummy.all[13]]),
        
        Internship(id: UUID(), title: "Web Developer Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[5], requiredSkills: [SkillDummy.all[0], SkillDummy.all[7]]),
        
        Internship(id: UUID(), title: "SQL Database Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[3]]),
        
        Internship(id: UUID(), title: "Cloud Engineer Intern", company: CompanyDummy.all[3], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[8], requiredSkills: [SkillDummy.all[15], SkillDummy.all[16]]),
        
        Internship(id: UUID(), title: "Digital Marketing Intern", company: CompanyDummy.all[4], sector: SectorDummy.marketing, minimumQualification: .bachelors, numberOfOpenings: 4, location: LocationDummy.all[9], requiredSkills: [SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Financial Modeling Intern", company: CompanyDummy.all[1], sector: SectorDummy.finance, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[6], requiredSkills: [SkillDummy.all[11], SkillDummy.all[12]]),
        
        Internship(id: UUID(), title: "Cybersecurity Intern", company: CompanyDummy.all[8], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 3, location: LocationDummy.all[16], requiredSkills: [SkillDummy.all[18]]),
        
        Internship(id: UUID(), title: "Java Developer Intern", company: CompanyDummy.all[9], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[18], requiredSkills: [SkillDummy.all[8]]),
        
        Internship(id: UUID(), title: "Product Design Intern", company: CompanyDummy.all[2], sector: SectorDummy.design, minimumQualification: .twelfth, numberOfOpenings: 2, location: LocationDummy.all[14], requiredSkills: [SkillDummy.all[5]]),
        
        Internship(id: UUID(), title: "React Developer Intern", company: CompanyDummy.all[5], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[7]]),
        
        Internship(id: UUID(), title: "Content Marketing Intern", company: CompanyDummy.all[4], sector: SectorDummy.marketing, minimumQualification: .twelfth, numberOfOpenings: 3, location: LocationDummy.all[10], requiredSkills: [SkillDummy.all[19]]),
        
        Internship(id: UUID(), title: "Data Analyst Intern", company: CompanyDummy.all[6], sector: SectorDummy.it, minimumQualification: .masters, numberOfOpenings: 2, location: LocationDummy.all[13], requiredSkills: [SkillDummy.all[12]])
    ]

}
