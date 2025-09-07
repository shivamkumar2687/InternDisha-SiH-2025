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
    @State private var offerReceivedInternships: [Internship] = []
    @State private var offerAcceptedInternships: [Internship] = []
    @State private var savedInternships: [Internship] = []
    @State private var showRemoveAlert = false
    @State private var internshipToRemove: Internship? = nil
    @State private var selectedTab: Int = 0
    private let userRepository = UserRepository()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Navigation Title
                Text("My Internship")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                // Top card section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // My Applications Card
                        statusCard(title: "My Applications", count: appliedInternships.count, systemImage: "doc.text.fill", color: .pink, index: 0)
                        
                        // Offer Received Card
                        statusCard(title: "Offered Received", count: offerReceivedInternships.count, systemImage: "envelope.fill", color: .teal, index: 1)
                        
                        // Offer Accepted Card
                        statusCard(title: "Offered Accepted", count: offerAcceptedInternships.count, systemImage: "checkmark.seal.fill", color: .purple, index: 2)
                        
                        // Saved Card
                        statusCard(title: "Saved", count: savedInternships.count, systemImage: "heart.fill", color: .orange, index: 3)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                // Content based on selected tab
                if selectedTab == 0 && appliedInternships.isEmpty {
                    emptyStateView(message: "You haven't applied to any internships yet", systemImage: "doc.text")
                } else if selectedTab == 1 && offerReceivedInternships.isEmpty {
                    emptyStateView(message: "No offers received yet", systemImage: "envelope")
                } else if selectedTab == 2 && offerAcceptedInternships.isEmpty {
                    emptyStateView(message: "No accepted offers yet", systemImage: "checkmark.seal")
                } else if selectedTab == 3 && savedInternships.isEmpty {
                    emptyStateView(message: "No saved internships", systemImage: "heart")
                } else {
                    // Title for the current section
                    HStack {
                        Text(sectionTitle)
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        Spacer()
                    }
                    
                    // List of internships based on selected tab
                    List {
                        ForEach(internshipsToShow) { internship in
                            AppliedInternshipCardView(internship: internship)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .contextMenu {
                                    if selectedTab == 3 {
                                        // Saved internships context menu
                                        Button(role: .destructive) {
                                            toggleSaveInternship(internship)
                                        } label: {
                                            Label("Unsave", systemImage: "heart.slash")
                                        }
                                    } else {
                                        // Applied internships context menu
                                        if selectedTab == 0 {
                                            Button {
                                                updateStatus(internship, status: .offerReceived)
                                            } label: {
                                                Label("Mark as Offer Received", systemImage: "envelope")
                                            }
                                        }
                                        
                                        if selectedTab == 1 {
                                            Button {
                                                updateStatus(internship, status: .offerAccepted)
                                            } label: {
                                                Label("Accept Offer", systemImage: "checkmark.seal")
                                            }
                                            
                                            Button {
                                                updateStatus(internship, status: .applied)
                                            } label: {
                                                Label("Mark as Applied", systemImage: "arrow.uturn.backward")
                                            }
                                        }
                                        
                                        Button(role: .destructive) {
                                            internshipToRemove = internship
                                            showRemoveAlert = true
                                        } label: {
                                            Label("Remove", systemImage: "trash")
                                        }
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    if selectedTab != 3 {
                                        Button {
                                            toggleSaveInternship(internship)
                                        } label: {
                                            Image(systemName: isSaved(internship) ? "heart.fill" : "heart")
                                                .foregroundColor(isSaved(internship) ? .red : .gray)
                                                .padding(8)
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
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
        .navigationTitle("My Internships")
        .onAppear {
                loadAllInternships()
            }
        }
    
    
    // MARK: - Helper Views
    
    private func statusCard(title: String, count: Int, systemImage: String, color: Color, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: systemImage)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("\(count)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            .frame(width: 100, height: 130)
            .background(RoundedRectangle(cornerRadius: 12).fill(selectedTab == index ? color.opacity(0.1) : Color.gray.opacity(0.05)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedTab == index ? color : Color.clear, lineWidth: 2))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func emptyStateView(message: String, systemImage: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding()
            
            Text(message)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Computed Properties
    
    private var sectionTitle: String {
        switch selectedTab {
        case 0: return "Your Applied Internships"
        case 1: return "Offers Received"
        case 2: return "Accepted Offers"
        case 3: return "Saved Internships"
        default: return ""
        }
    }
    
    private var internshipsToShow: [Internship] {
        switch selectedTab {
        case 0: return appliedInternships
        case 1: return offerReceivedInternships
        case 2: return offerAcceptedInternships
        case 3: return savedInternships
        default: return []
        }
    }
    
    // MARK: - Data Loading and Actions
    
    private func loadAllInternships() {
        // Load applied internships and filter by status
        let allApplied = userRepository.loadAppliedInternships()
        appliedInternships = allApplied.filter { $0.status == nil || $0.status == .applied }
        offerReceivedInternships = userRepository.getInternshipsByStatus(.offerReceived)
        offerAcceptedInternships = userRepository.getInternshipsByStatus(.offerAccepted)
        
        // Load saved internships
        savedInternships = userRepository.loadSavedInternships()
    }
    
    private func removeInternship(_ internship: Internship) {
        if userRepository.removeAppliedInternship(internship) {
            // Add the internship back to the Internship tab
            internshipViewModel.addInternship(internship)
            
            // Refresh the lists after removal
            loadAllInternships()
        }
    }
    
    private func updateStatus(_ internship: Internship, status: InternshipStatus) {
        if userRepository.updateInternshipStatus(internship, status: status) {
            // Refresh the lists after status update
            loadAllInternships()
        }
    }
    
    private func toggleSaveInternship(_ internship: Internship) {
        _ = userRepository.toggleSaveInternship(internship)
        loadAllInternships()
    }
    
    private func isSaved(_ internship: Internship) -> Bool {
        return savedInternships.contains(where: { $0.id == internship.id })
    }
}

#Preview {
    MyInternshipView()
        .environmentObject(InternshipViewModel())
}
