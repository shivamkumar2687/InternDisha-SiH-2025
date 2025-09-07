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
                    Label("Internship", systemImage: "briefcase")
                }
            MyInternshipView()
                .environmentObject(internshipViewModel)
                .tabItem {
                    Label("My Internship", systemImage: "heart")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
