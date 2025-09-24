import Foundation
import UserNotifications

struct NotificationRequest {
    let id: String
    let title: String
    let body: String
    let date: Date
    let daysBefore: Int // За сколько дней до события отправить уведомление
}

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for request: NotificationRequest) {
        let center = UNUserNotificationCenter.current()
        
        // Уведомление "за N дней"
        if let notificationDate = Calendar.current.date(byAdding: .day, value: -request.daysBefore, to: request.date) {
            let content = UNMutableNotificationContent()
            content.title = request.title
            content.body = "Don't forget! Only \(request.daysBefore) day(s) left until \(request.body)."
            content.sound = .default

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let notificationId = "\(request.id)-before"
            let unRequest = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
            center.add(unRequest)
        }
        
        // Уведомление "в день события"
        let contentDayOf = UNMutableNotificationContent()
        contentDayOf.title = request.title
        contentDayOf.body = "Today is \(request.body)!"
        contentDayOf.sound = .default
        
        var dateComponentsDayOf = Calendar.current.dateComponents([.year, .month, .day], from: request.date)
        dateComponentsDayOf.hour = 9 // Утром в 9:00
        let triggerDayOf = UNCalendarNotificationTrigger(dateMatching: dateComponentsDayOf, repeats: false)

        let notificationIdDayOf = "\(request.id)-dayof"
        let unRequestDayOf = UNNotificationRequest(identifier: notificationIdDayOf, content: contentDayOf, trigger: triggerDayOf)
        center.add(unRequestDayOf)
    }
    
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(id)-before", "\(id)-dayof"])
    }
}
