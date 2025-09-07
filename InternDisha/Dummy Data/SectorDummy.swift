
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
    
    static let all: [Sector] = [it, finance, design]
}
