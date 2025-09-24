import Foundation
import RealmSwift
import Combine

protocol GiftIdeaRepositoryProtocol {
    func fetchIdeas() -> AnyPublisher<[GiftIdeaObject], Error>
}

class GiftIdeaRepository: GiftIdeaRepositoryProtocol {
    private let realm = RealmManager.shared.realm
    
    func fetchIdeas() -> AnyPublisher<[GiftIdeaObject], Error> {
        let results = realm.objects(GiftIdeaObject.self).sorted(byKeyPath: "title")
        
        return results.collectionPublisher
            .map { Array($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
