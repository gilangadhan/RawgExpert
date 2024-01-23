import Foundation
import RealmSwift
import Core
import Games
import Detail
import Favorite
import SwiftUI

final class DependencyInjection: NSObject {

  private let realm = try? Realm()

  func provideGames<U: UseCase>() -> U where U.Request == Any, U.Response == [GameDomainModel] {
    let locale = GetGamesLocaleDataSource(realm: realm!)
    let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.games.url)
    let mapper = GameTransformer()
    let repository = GetGamesRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  func provideSearch<U: UseCase>() -> U where U.Request == String, U.Response == [GameDomainModel] {
    let locale = GetSearchLocaleDataSource(realm: realm!)
    let remote = GetSearchRemoteDataSource(endpoint: Endpoints.Gets.search.url)
    let mapper = SearchTransformer()
    let repository = SearchRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  func provideDetail<U: UseCase>(detail: GameDomainModel) -> U where U.Request == Int, U.Response == GameDomainModel {
    let locale = GetDetailLocaleDataSource(realm: realm!)
    let remote = GetDetailRemoteDataSource(endpoint: Endpoints.Gets.gameById(detail.id).url)
    let mapper = DetailTransformer()
    let repository = GetDetailRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  func provideFavorite<U: UseCase>() -> U where U.Request == Int, U.Response == [GameDomainModel] {
    let locale = GetFavoriteLocaleDataSource(realm: realm!)
    let mapper = FavoriteListTransformer()
    let repository = GetFavoriteRepository(localeDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

  func provideUpdateFavorite<U: UseCase>() -> U where U.Request == Int, U.Response == GameDomainModel {
    let locale = GetFavoriteLocaleDataSource(realm: realm!)
    let mapper = FavoriteTransformer()
    let repository = UpdateFavoriteRepository(localeDataSource: locale, mapper: mapper)
    return Interactor(repository: repository) as! U
  }

}
