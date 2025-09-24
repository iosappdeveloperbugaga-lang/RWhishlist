import Foundation
import Combine
import RealmSwift

class SchedulerViewModel: ObservableObject {
    @Published var events: [EventObject] = []
    @Published var showingAddEventSheet = false
    
    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: EventRepositoryProtocol = EventRepository()) {
        self.repository = repository
        fetchEvents()
    }
    
    func fetchEvents() {
        repository.fetchEvents()
            .map { events in
                // Фильтруем только будущие события
                events.filter { $0.date >= Date() }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] events in
                self?.events = events
            })
            .store(in: &cancellables)
    }
    
    func deleteEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = events[index]
            do {
                try repository.deleteEvent(id: event.id)
            } catch {
                print("Failed to delete event: \(error)")
            }
        }
    }
}
