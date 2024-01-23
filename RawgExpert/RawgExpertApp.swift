import SwiftUI
import Core
import Games
import Favorite
import RealmSwift

// New
let gameUseCase: Interactor<
  Any, [GameDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>> = DependencyInjection.init().provideGames()

let searchUseCase: Interactor<String, [GameDomainModel], SearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, SearchTransformer>> = DependencyInjection.init().provideSearch()

let favoriteUseCase: Interactor<Int, [GameDomainModel], GetFavoriteRepository<GetFavoriteLocaleDataSource, FavoriteListTransformer>> = DependencyInjection.init().provideFavorite()

@main
struct RawgExpertApp: SwiftUI.App {

  let homePresenter = GetListPresenter(useCase: gameUseCase)
  let searchPresenter = SearchPresenter(useCase: searchUseCase)
  let favoritePresenter = FavoritePresenter(useCase: favoriteUseCase)

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
        .environmentObject(searchPresenter)
        .environmentObject(favoritePresenter)
    }
  }
}
