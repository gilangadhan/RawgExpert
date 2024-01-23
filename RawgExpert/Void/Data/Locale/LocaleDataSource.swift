import Foundation
import Combine
import RealmSwift

protocol LocaleDataSourceProtocol: AnyObject {
  func getGames() -> AnyPublisher<[GameEntity], Error>
  func getGame(by id: Int) -> AnyPublisher<GameEntity, Error>
  func addGame(from games: [GameEntity]) -> AnyPublisher<Bool, Error>
  func updateGame(by id: Int, detail: GameEntity) -> AnyPublisher<Bool, Error>
  func getFavorite() -> AnyPublisher<[GameEntity], Error>
  func updateFavorite(by id: Int) -> AnyPublisher<GameEntity, Error>
  func addGameBy(_ name: String, from games: [GameEntity]) -> AnyPublisher<Bool, Error>
  func getGameBy(_ name: String) -> AnyPublisher<[GameEntity], Error>
}

final class LocaleDataSource: NSObject {

  private let realm: Realm?
  private init(realm: Realm?) {
    self.realm = realm
  }

  static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
    return LocaleDataSource(realm: realmDatabase)
  }
}

extension LocaleDataSource: LocaleDataSourceProtocol {

  func getGames() -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { result in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
        }()
        result(.success(games.toArray(ofType: GameEntity.self)))
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getGame(by id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { result in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
            .filter("id = \(id)")
        }()

        guard let game = games.first else {
          result(.failure(DatabaseError.requestFailed))
          return
        }

        result(.success(game))
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addGame(from games: [GameEntity]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { result in
      if let realm = self.realm {
        do {
          try realm.write {
            for game in games {
              realm.add(game, update: .all)
            }
            result(.success(true))
          }
        } catch {
          result(.failure(DatabaseError.requestFailed))
        }
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }
    .eraseToAnyPublisher()
  }

  func updateGame(by id: Int, detail: GameEntity) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { result in
      if let realm = self.realm, let gameEntity = {
        realm.objects(GameEntity.self).filter("id == \(id)")
      }().first {
        do {
          try realm.write {
            gameEntity.setValue(detail.descriptions, forKey: "descriptions")
            gameEntity.setValue(detail.backgroundImage, forKey: "backgroundImage")
            gameEntity.setValue(detail.isFavorite, forKey: "isFavorite")
          }
          result(.success(true))
        } catch {
          result(.failure(DatabaseError.requestFailed))
        }
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getFavorite() -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { result in
      if let realm = self.realm {
        let gameEntities = {
          realm.objects(GameEntity.self)
            .filter("isFavorite = \(true)")
            .sorted(byKeyPath: "title", ascending: true)
        }()
        result(.success(gameEntities.toArray(ofType: GameEntity.self)))
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func updateFavorite(by id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { result in
      if let realm = self.realm, let gameEntity = {
        realm.objects(GameEntity.self)
          .filter("id == \(id)")
      }().first {
        do {
          try realm.write {
            gameEntity.setValue(!gameEntity.isFavorite, forKey: "isFavorite")
          }
          result(.success(gameEntity))
        } catch {
          result(.failure(DatabaseError.requestFailed))
        }
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func addGameBy(_ name: String, from games: [GameEntity]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { result in
      if let realm = self.realm {
        do {
          try realm.write {
            for game in games {
              if let gameEntity = realm.object(ofType: GameEntity.self, forPrimaryKey: game.id) {
                if gameEntity.title == game.title {
                  game.isFavorite = gameEntity.isFavorite
                  realm.add(game, update: .all)
                } else {
                  realm.add(game)
                }
              } else {
                realm.add(game)
              }
            }
          }
          result(.success(true))
        } catch {
          result(.failure(DatabaseError.requestFailed))
        }
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  func getGameBy(_ name: String) -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { result in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
            .filter("title contains[c] %@", name)
            .sorted(byKeyPath: "title")
        }()
        result(.success(games.toArray(ofType: GameEntity.self)))
      } else {
        result(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}
