//
//  ContentView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 06/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            InternshipView()
                .tabItem{
                    Label("Internship", systemImage: "person.crop.circle")
                }
            MyInternshipView()
                .tabItem {
                    Label("My Internship", systemImage: "person.crop.circle")
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
