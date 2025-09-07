//
//  InternshipData.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import Foundation


struct InternshipDummy {
    static let all: [Internship] = [
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
        
        Internship(id: UUID(), title: "SQL Database Intern", company: CompanyDummy.all[0], sector: SectorDummy.it, minimumQualification: .bachelors, numberOfOpenings: 2, location: LocationDummy.all[0], requiredSkills: [SkillDummy.all[3]])
    ]
}
