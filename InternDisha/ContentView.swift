//
//  ContentView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 06/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var internshipViewModel = InternshipViewModel()
    var body: some View {
        TabView{
            InternshipView()
                .environmentObject(internshipViewModel)
                .tabItem{
                    Label(String(localized: "Internship"), systemImage: "briefcase")
                }
            MyInternshipView()
                .environmentObject(internshipViewModel)
                .tabItem {
                    Label(String(localized: "My Internship"), systemImage: "heart")
                }
            NavigationStack { ProfileView() }
                .tabItem {
                    Label(String(localized: "Profile"), systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
