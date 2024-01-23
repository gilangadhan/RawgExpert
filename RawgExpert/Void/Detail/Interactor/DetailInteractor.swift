import Foundation
import Combine

protocol DetailUseCase {

  func getGame() -> GameModel
  func getGame() -> AnyPublisher<GameModel, Error>
  func updateFavorite() -> AnyPublisher<GameModel, Error>

}

class DetailInteractor: DetailUseCase {

  private let repository: GameRepositoryProtocol
  private let detail: GameModel

  required init(repository: GameRepositoryProtocol, detail: GameModel) {
    self.repository = repository
    self.detail = detail
  }

  func getGame() -> GameModel {
    return detail
  }

  func getGame() -> AnyPublisher<GameModel, Error> {
    return repository.getGame(by: detail.id)
  }

  func updateFavorite() -> AnyPublisher<GameModel, Error> {
    return repository.updateFavorite(by: detail.id)
  }
}
