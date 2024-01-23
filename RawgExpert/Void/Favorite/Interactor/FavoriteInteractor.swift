import Foundation
import Combine

protocol FavoriteUseCase {
  func getFavorite() -> AnyPublisher<[GameModel], Error>
}

class FavoriteInteractor: FavoriteUseCase {

  private let repository: GameRepositoryProtocol
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }

  func getFavorite() -> AnyPublisher<[GameModel], Error> {
    return repository.getFavorite()
  }
}
