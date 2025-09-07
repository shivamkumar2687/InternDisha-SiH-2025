//
//  Internship.swift
//  InternDisha
//
//  Created by Shivam Kumar on 07/09/25.
//
import SwiftUI
import Combine

struct InternshipView: View {
    @EnvironmentObject var viewModel: InternshipViewModel
    @State private var showFilters = false
    @State private var showAbout: Internship?
    @State private var showAppliedAlert = false
    @State private var appliedInternship: Internship?
    @State private var selectedSegment = 1 // 0 = Vacant, 1 = Overall (default)

    private let userRepository = UserRepository()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(helloTitle)
                .toolbarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showFilters = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        .accessibilityLabel("Filter")
                    }
                }
        }
        .sheet(isPresented: $showFilters) {
            InternshipFilterSheet(
                selectedSkillIds: $viewModel.selectedSkillIds,
                selectedLocationIds: $viewModel.selectedLocationIds,
                allSkills: viewModel.allSkills,
                allLocations: viewModel.allLocations
            )
        }
        .sheet(item: $showAbout) { internship in
            InternshipAboutView(
                internship: internship,
                descriptionText: aboutDescription(for: internship)
            )
        }
        .alert("Application Successful", isPresented: $showAppliedAlert) {
            Button("Done") {
                if let internship = appliedInternship {
                    userRepository.addAppliedInternship(internship)
                    // Remove the applied internship from the filtered list
                    viewModel.removeInternship(internship)
                    appliedInternship = nil
                }
            }
        } message: {
            Text("You have successfully applied for this internship.")
        }
    }

    private var content: some View {
        List {
            Section {
                SearchField(text: $viewModel.searchText)
                
                // Segmented Control
                Picker("View Mode", selection: $selectedSegment) {
                    Text("Recommended").tag(0)
                    Text("Overall").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 8)
                .onChange(of: selectedSegment) { _ in
                    viewModel.setViewMode(recommended: selectedSegment == 0)
                }
            }

            ForEach(viewModel.filtered) { internship in
                InternshipCardView(
                    internship: internship,
                    applyAction: { 
                        appliedInternship = internship
                        showAppliedAlert = true 
                    },
                    aboutAction: { withAnimation(.snappy) { showAbout = internship } }
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
        .refreshable { await viewModel.refresh() }
        .animation(.snappy, value: viewModel.filtered.map { $0.id })
    }

    private var helloTitle: String {
        if let user = userRepository.loadCurrentUser() {
            return "Hello, \(user.firstName)"
        }
        return "Hello"
    }



    private func aboutDescription(for internship: Internship) -> String {
        "This is a great opportunity to work as \(internship.title) at \(internship.company.name). You will collaborate with a team, learn \(internship.requiredSkills.map { $0.name }.joined(separator: ", ")), and contribute to real projects. Location: \(internship.location.city ?? internship.location.district), \(internship.location.state)."
    }
}

#Preview {
    InternshipView()
        .environmentObject(InternshipViewModel())
}

// MARK: - Search Field
private struct SearchField: View {
    @Binding var text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search internships…", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
            if !text.isEmpty {
                Button {
                    withAnimation(.easeInOut) { text = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.thinMaterial))
    }
}
