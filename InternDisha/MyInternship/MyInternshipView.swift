//
//  MyInternshipView.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//

import SwiftUI

struct MyInternshipView: View {    
    @EnvironmentObject var internshipViewModel: InternshipViewModel
    @State private var appliedInternships: [Internship] = []
    @State private var showRemoveAlert = false
    @State private var internshipToRemove: Internship? = nil
    private let userRepository = UserRepository()
    
    var body: some View {
        NavigationStack {
            if appliedInternships.isEmpty {
                VStack {
                    Image(systemName: "briefcase")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No Applied Internships")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("When you apply for internships, they will appear here.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            } else {
                VStack(alignment: .leading) {
                    Text("Your Applied Internships")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    List {
                        ForEach(appliedInternships) { internship in
                            AppliedInternshipCardView(internship: internship)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        internshipToRemove = internship
                                        showRemoveAlert = true
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    internshipToRemove = internship
                                    showRemoveAlert = true
                                }
                        }
                    }
                    .listStyle(.plain)
                }
                .alert("Remove Internship", isPresented: $showRemoveAlert, presenting: internshipToRemove) { internship in
                    Button("Cancel", role: .cancel) {
                        internshipToRemove = nil
                    }
                    Button("Remove", role: .destructive) {
                        removeInternship(internship)
                    }
                } message: { internship in
                    Text("Are you sure you want to remove \(internship.title) from your applied internships?")
                }
            }
        }
        .navigationTitle("My Internships")
        .onAppear {
                loadAppliedInternships()
            }
        }
    
    
    private func loadAppliedInternships() {
        appliedInternships = userRepository.loadAppliedInternships()
    }
    
    private func removeInternship(_ internship: Internship) {
        if userRepository.removeAppliedInternship(internship) {
            // Add the internship back to the Internship tab
            internshipViewModel.addInternship(internship)
            
            // Refresh the list after removal
            loadAppliedInternships()
        }
    }
}

#Preview {
    MyInternshipView()
        .environmentObject(InternshipViewModel())
}
