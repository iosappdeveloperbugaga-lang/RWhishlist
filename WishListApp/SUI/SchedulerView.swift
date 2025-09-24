import SwiftUI

struct SchedulerView: View {
    @StateObject private var viewModel = SchedulerViewModel()
    @State private var uiid: UUID = UUID()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.events.isEmpty {
                    EmptyStateView(
                        imageName: "calendar.badge.plus",
                        title: "No Upcoming Events",
                        description: "Add a holiday date or a special occasion to start planning your perfect gifts!",
                        buttonTitle: "Add Holiday Date"
                    ) {
                        viewModel.showingAddEventSheet = true
                    }
                } else {
                    List {
                        ForEach(viewModel.events) { event in
                            EventRowView(event: event)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.appBackground)
                        }
                        .onDelete(perform: viewModel.deleteEvent)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .id(uiid)
                }
            }
            .navigationTitle("Scheduler")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingAddEventSheet = true }) {
                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.accent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddEventSheet) {
                 AddEventView()
                    .onDisappear {
                        uiid = UUID()
                    }
                    
            }
        }
    }
}
