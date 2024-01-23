import Foundation
import Combine

protocol SearchUseCase {
  func search(by name: String) -> AnyPublisher<[GameModel], Error>
}

class SearchInteractor: SearchUseCase {

  private let repository: GameRepositoryProtocol
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }

  func search(by name: String) -> AnyPublisher<[GameModel], Error> {
    return repository.search(by: name)
  }
}
