import Foundation
import RealmSwift
import Combine

protocol EventRepositoryProtocol {
    func fetchEvents() -> AnyPublisher<[EventObject], Error>
    func addEvent(title: String, date: Date, linkedWishlistId: ObjectId?) throws
    func deleteEvent(id: ObjectId) throws
}

class EventRepository: EventRepositoryProtocol {
    private let realm = RealmManager.shared.realm
    
    func fetchEvents() -> AnyPublisher<[EventObject], Error> {
        let results = realm.objects(EventObject.self).sorted(byKeyPath: "date", ascending: true)
        
        return results.collectionPublisher
            .map { Array($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func addEvent(title: String, date: Date, linkedWishlistId: ObjectId?) throws {
        let newEvent = EventObject()
        newEvent.title = title
        newEvent.date = date
        newEvent.linkedWishlistId = linkedWishlistId
        
        try RealmManager.shared.write { realm in
            realm.add(newEvent)
        }
        
        // Schedule notifications for the new event
        let notificationRequest = NotificationRequest(
            id: newEvent.id.stringValue,
            title: "Upcoming Event Reminder",
            body: newEvent.title,
            date: newEvent.date,
            daysBefore: 7 // По умолчанию за 7 дней
        )
        NotificationManager.shared.scheduleNotification(for: notificationRequest)
    }
    
    func deleteEvent(id: ObjectId) throws {
        guard let eventToDelete = realm.object(ofType: EventObject.self, forPrimaryKey: id) else { return }
        
        // Cancel notifications before deleting
        NotificationManager.shared.cancelNotification(id: eventToDelete.id.stringValue)
        
        try RealmManager.shared.write { realm in
            realm.delete(eventToDelete)
        }
    }
}
