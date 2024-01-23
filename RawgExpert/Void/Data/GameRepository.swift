import Foundation
import Combine

protocol GameRepositoryProtocol {

  func getGames() -> AnyPublisher<[GameModel], Error>
  func getGame(by id: Int) -> AnyPublisher<GameModel, Error>
  func getFavorite() -> AnyPublisher<[GameModel], Error>
  func updateFavorite(by id: Int) -> AnyPublisher<GameModel, Error>
  func search(by name: String) -> AnyPublisher<[GameModel], Error>
}

final class GameRepository: NSObject {

  typealias GameInstance = (LocaleDataSource, RemoteDataSource) -> GameRepository
  fileprivate let remote: RemoteDataSource
  fileprivate let locale: LocaleDataSource

  private init(locale: LocaleDataSource, remote: RemoteDataSource) {
    self.locale = locale
    self.remote = remote
  }

  static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
    return GameRepository(locale: localeRepo, remote: remoteRepo)
  }
}

extension GameRepository: GameRepositoryProtocol {

  func getGames() -> AnyPublisher<[GameModel], Error> {
    return self.locale.getGames()
      .flatMap { result -> AnyPublisher<[GameModel], Error> in
        if result.isEmpty {
          return self.remote.getGames()
            .map { GameMapper.mapGameResponsesToEntities(input: $0) }
            .flatMap { self.locale.addGame(from: $0) }
            .filter { $0 }
            .flatMap { _ in self.locale.getGames()
                .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
            }
            .eraseToAnyPublisher()
        } else {
          return self.locale.getGames()
            .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }

  func getGame(by id: Int) -> AnyPublisher<GameModel, Error> {
    return self.locale.getGame(by: id)
      .flatMap { result -> AnyPublisher<GameModel, Error> in
        if result.descriptions == "" {
          return self.remote.getGame(by: id)
            .map { GameMapper.mapGameDetailResponsesToEntity(by: id, input: $0) }
            .catch { _ in self.locale.getGame(by: id) }
            .flatMap { self.locale.updateGame(by: id, detail: $0) }
            .filter { $0 }
            .flatMap { _ in self.locale.getGame(by: id)
                .map { GameMapper.mapDetailEntityToDomain(input: $0) }
            }.eraseToAnyPublisher()
        } else {
          return self.locale.getGame(by: id)
            .map { GameMapper.mapDetailEntityToDomain(input: $0) }
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }

  func getFavorite() -> AnyPublisher<[GameModel], Error> {
    return self.locale.getFavorite()
      .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }

  func updateFavorite(by id: Int) -> AnyPublisher<GameModel, Error> {
    return self.locale.updateFavorite(by: id)
      .map { GameMapper.mapDetailEntityToDomain(input: $0) }
      .eraseToAnyPublisher()
  }

  func search(by name: String) -> AnyPublisher<[GameModel], Error> {
    return self.remote.search(by: name)
      .map { GameMapper.mapDetailResponseToEntity(input: $0) }
      .catch { _ in self.locale.getGameBy(name) }
      .flatMap { result in
        self.locale.getGameBy(name)
          .flatMap { locale -> AnyPublisher<[GameModel], Error> in
            if result.count > locale.count {
              return self.locale.addGameBy(name, from: result)
                .filter { $0 }
                .flatMap { _ in self.locale.getGameBy(name)
                    .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                }.eraseToAnyPublisher()
            } else {
              return self.locale.getGameBy(name)
                .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                .eraseToAnyPublisher()
            }
          }
      }.eraseToAnyPublisher()
  }
}
