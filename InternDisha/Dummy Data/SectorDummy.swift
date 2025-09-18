
import Foundation

import Foundation

struct SectorDummy {
//    static let it = Sector(
//        id: UUID(),
//        name: "IT",
//        areas: [
//            Area(id: UUID(), name: "Mobile Development"),
//            Area(id: UUID(), name: "Web Development"),
//            Area(id: UUID(), name: "Data Science")
//        ]
//    )
//    
//    static let finance = Sector(
//        id: UUID(),
//        name: "Finance",
//        areas: [
//            Area(id: UUID(), name: "Accounting"),
//            Area(id: UUID(), name: "Investment Banking"),
//            Area(id: UUID(), name: "FinTech")
//        ]
//    )
//    
//    static let design = Sector(
//        id: UUID(),
//        name: "Design",
//        areas: [
//            Area(id: UUID(), name: "UI/UX"),
//            Area(id: UUID(), name: "Graphic Design")
//        ]
//    )
//    
//    static let all: [Sector] = [it, finance, design]
    static let it = Sector(
        id: UUID(),
        name: "IT",
        areas: [
            Area(id: UUID(), name: "Software Development"),
            Area(id: UUID(), name: "Data Science"),
            Area(id: UUID(), name: "Cybersecurity"),
            Area(id: UUID(), name: "Cloud Computing")
        ]
    )

    static let finance = Sector(
        id: UUID(),
        name: "Finance",
        areas: [
            Area(id: UUID(), name: "Accounting"),
            Area(id: UUID(), name: "Investment Banking"),
            Area(id: UUID(), name: "FinTech"),
            Area(id: UUID(), name: "Financial Analysis")
        ]
    )

    static let design = Sector(
        id: UUID(),
        name: "Design",
        areas: [
            Area(id: UUID(), name: "UI/UX Design"),
            Area(id: UUID(), name: "Graphic Design"),
            Area(id: UUID(), name: "Product Design"),
            Area(id: UUID(), name: "Animation")
        ]
    )

    static let marketing = Sector(
        id: UUID(),
        name: "Marketing",
        areas: [
            Area(id: UUID(), name: "Digital Marketing"),
            Area(id: UUID(), name: "Content Creation"),
            Area(id: UUID(), name: "SEO"),
            Area(id: UUID(), name: "Social Media")
        ]
    )

    static let all: [Sector] = [it, finance, design, marketing]

}
