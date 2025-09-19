
import Foundation

import Foundation

struct SectorDummy {
    static let it = Sector(
        id: UUID(),
        name: "IT",
        areas: [
            Area(id: UUID(), name: "Mobile Development"),
            Area(id: UUID(), name: "Web Development"),
            Area(id: UUID(), name: "Data Science")
        ]
    )
    
    static let finance = Sector(
        id: UUID(),
        name: "Finance",
        areas: [
            Area(id: UUID(), name: "Accounting"),
            Area(id: UUID(), name: "Investment Banking"),
            Area(id: UUID(), name: "FinTech")
        ]
    )
    
    static let design = Sector(
        id: UUID(),
        name: "Design",
        areas: [
            Area(id: UUID(), name: "UI/UX"),
            Area(id: UUID(), name: "Graphic Design")
        ]
    )
    
    static let healthcare = Sector(
        id: UUID(),
        name: "Healthcare",
        areas: [
            Area(id: UUID(), name: "Medical Research"),
            Area(id: UUID(), name: "Healthcare Administration"),
            Area(id: UUID(), name: "Biotechnology")
        ]
    )
    
    static let education = Sector(
        id: UUID(),
        name: "Education",
        areas: [
            Area(id: UUID(), name: "Teaching"),
            Area(id: UUID(), name: "EdTech"),
            Area(id: UUID(), name: "Curriculum Development")
        ]
    )
    
    static let marketing = Sector(
        id: UUID(),
        name: "Marketing",
        areas: [
            Area(id: UUID(), name: "Digital Marketing"),
            Area(id: UUID(), name: "Content Creation"),
            Area(id: UUID(), name: "Brand Management")
        ]
    )
    
    static let engineering = Sector(
        id: UUID(),
        name: "Engineering",
        areas: [
            Area(id: UUID(), name: "Civil Engineering"),
            Area(id: UUID(), name: "Mechanical Engineering"),
            Area(id: UUID(), name: "Electrical Engineering")
        ]
    )
    
    static let retail = Sector(
        id: UUID(),
        name: "Retail",
        areas: [
            Area(id: UUID(), name: "E-commerce"),
            Area(id: UUID(), name: "Supply Chain"),
            Area(id: UUID(), name: "Merchandising")
        ]
    )
    
    static let media = Sector(
        id: UUID(),
        name: "Media",
        areas: [
            Area(id: UUID(), name: "Journalism"),
            Area(id: UUID(), name: "Broadcasting"),
            Area(id: UUID(), name: "Social Media")
        ]
    )
    
    static let hospitality = Sector(
        id: UUID(),
        name: "Hospitality",
        areas: [
            Area(id: UUID(), name: "Hotel Management"),
            Area(id: UUID(), name: "Tourism"),
            Area(id: UUID(), name: "Event Planning")
        ]
    )
    
    static let agriculture = Sector(
        id: UUID(),
        name: "Agriculture",
        areas: [
            Area(id: UUID(), name: "Farming"),
            Area(id: UUID(), name: "AgriTech"),
            Area(id: UUID(), name: "Food Processing")
        ]
    )
    
    static let energy = Sector(
        id: UUID(),
        name: "Energy",
        areas: [
            Area(id: UUID(), name: "Renewable Energy"),
            Area(id: UUID(), name: "Oil & Gas"),
            Area(id: UUID(), name: "Energy Management")
        ]
    )
    
    static let automotive = Sector(
        id: UUID(),
        name: "Automotive",
        areas: [
            Area(id: UUID(), name: "Vehicle Design"),
            Area(id: UUID(), name: "Manufacturing"),
            Area(id: UUID(), name: "Electric Vehicles")
        ]
    )
    
    static let realestate = Sector(
        id: UUID(),
        name: "Real Estate",
        areas: [
            Area(id: UUID(), name: "Property Management"),
            Area(id: UUID(), name: "Construction"),
            Area(id: UUID(), name: "Architecture")
        ]
    )
    
    static let legal = Sector(
        id: UUID(),
        name: "Legal",
        areas: [
            Area(id: UUID(), name: "Corporate Law"),
            Area(id: UUID(), name: "Intellectual Property"),
            Area(id: UUID(), name: "Legal Research")
        ]
    )
    
    static let manufacturing = Sector(
        id: UUID(),
        name: "Manufacturing",
        areas: [
            Area(id: UUID(), name: "Production"),
            Area(id: UUID(), name: "Quality Control"),
            Area(id: UUID(), name: "Industrial Design")
        ]
    )
    
    static let logistics = Sector(
        id: UUID(),
        name: "Logistics",
        areas: [
            Area(id: UUID(), name: "Supply Chain Management"),
            Area(id: UUID(), name: "Transportation"),
            Area(id: UUID(), name: "Warehouse Management")
        ]
    )
    
    static let telecommunications = Sector(
        id: UUID(),
        name: "Telecommunications",
        areas: [
            Area(id: UUID(), name: "Network Engineering"),
            Area(id: UUID(), name: "Telecom Services"),
            Area(id: UUID(), name: "Wireless Communications")
        ]
    )
    
    static let consulting = Sector(
        id: UUID(),
        name: "Consulting",
        areas: [
            Area(id: UUID(), name: "Management Consulting"),
            Area(id: UUID(), name: "Strategy Consulting"),
            Area(id: UUID(), name: "IT Consulting")
        ]
    )
    
    static let entertainment = Sector(
        id: UUID(),
        name: "Entertainment",
        areas: [
            Area(id: UUID(), name: "Film Production"),
            Area(id: UUID(), name: "Gaming"),
            Area(id: UUID(), name: "Music")
        ]
    )
    
    static let all: [Sector] = [
        it, finance, design, healthcare, education, marketing, engineering, retail, 
        media, hospitality, agriculture, energy, automotive, realestate, legal, 
        manufacturing, logistics, telecommunications, consulting, entertainment
    ]
}
