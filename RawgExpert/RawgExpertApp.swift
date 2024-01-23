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


// SwiftLint

//# Type a script or drag a script file from your workspace to insert its path.
//if [[ "$(uname -m)" == arm64 ]]; then
//    export PATH="/opt/homebrew/bin:$PATH"
//fi
//
//if which swiftlint > /dev/null; then
//  swiftlint
//else
//  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
//fi
