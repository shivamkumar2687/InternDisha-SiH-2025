//
//  AdminContentView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 17/09/25.
//

import SwiftUI

struct AdminContentView: View {
    @StateObject private var internshipViewModel = InternshipViewModel()
    
    var body: some View {
        TabView {
            AdminDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            InternshipManagementView()
                .environmentObject(internshipViewModel)
                .tabItem {
                    Label("Internships", systemImage: "briefcase.fill")
                }
            
            UserManagementView()
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
            
            NavigationStack { ProfileView() }
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct AdminDashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Welcome back, Admin!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "person.badge.key")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        Text("Here's what's happening on InternDisha")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Quick Stats
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatCard(title: "Total Students", value: "\(auth.getUsersByRole(.student).count)", icon: "graduationcap.fill", color: .blue)
                        StatCard(title: "Total Internships", value: "15", icon: "briefcase.fill", color: .green)
                        StatCard(title: "Applications", value: "42", icon: "doc.text.fill", color: .orange)
                        StatCard(title: "Active Users", value: "8", icon: "person.2.fill", color: .purple)
                    }
                    .padding(.horizontal)
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            ActivityRow(icon: "plus.circle.fill", text: "New internship posted by TechCorp", time: "2h ago", color: .green)
                            ActivityRow(icon: "person.fill.badge.plus", text: "New student registration", time: "4h ago", color: .blue)
                            ActivityRow(icon: "doc.text.fill", text: "Application submitted for Data Analyst role", time: "6h ago", color: .orange)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

//struct StatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            HStack {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(color)
//                Spacer()
//            }
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(value)
//                    .font(.title)
//                    .fontWeight(.bold)
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 2)
//    }
//}

//struct ActivityRow: View {
//    let icon: String
//    let text: String
//    let time: String
//    let color: Color
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: icon)
//                .font(.title3)
//                .foregroundColor(color)
//                .frame(width: 20)
//            
//            Text(text)
//                .font(.subheadline)
//            
//            Spacer()
//            
//            Text(time)
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
//    }
//}

// Placeholder views for other admin tabs
//struct InternshipManagementView: View {
//    var body: some View {
//        NavigationView {
//            Text("Internship Management")
//                .font(.title)
//                .navigationTitle("Manage Internships")
//        }
//    }
//}

//struct UserManagementView: View {
//    @EnvironmentObject var auth: AuthViewModel
//    
//    var body: some View {
//        NavigationView {
//            List {
//                Section("Students") {
//                    ForEach(auth.getUsersByRole(.student)) { user in
//                        UserRow(user: user)
//                    }
//                }
//                
//                Section("Admins") {
//                    ForEach(auth.getUsersByRole(.admin)) { user in
//                        UserRow(user: user)
//                    }
//                }
//            }
//            .navigationTitle("Users")
//        }
//    }
//}

//struct UserRow: View {
//    let user: User
//    
//    var body: some View {
//        HStack {
//            Image(systemName: user.role.systemImage)
//                .foregroundColor(.blue)
//                .frame(width: 20)
//            
//            VStack(alignment: .leading) {
//                Text("\(user.firstName) \(user.lastName)")
//                    .font(.headline)
//                Text(user.email)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            Text(user.role.displayName)
//                .font(.caption)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(Color.blue.opacity(0.1))
//                .cornerRadius(6)
//        }
//    }
//}

struct AdminAnalyticsView: View {
    var body: some View {
        NavigationView {
            Text("Analytics & Reports")
                .font(.title)
                .navigationTitle("Analytics")
        }
    }
}

#Preview {
    AdminContentView()
        .environmentObject(AuthViewModel())
}



