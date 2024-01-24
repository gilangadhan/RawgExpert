import SwiftUI
import Core
import Games
import Favorite

struct ContentView: View {

  @EnvironmentObject var homePresenter: GetListPresenter<Any, GameDomainModel, Interactor<Any, [GameDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>>

  @EnvironmentObject var searchPresenter: SearchPresenter<GameDomainModel, Interactor<String, [GameDomainModel], SearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, SearchTransformer>>>

  @EnvironmentObject var favoritePresenter: FavoritePresenter<Int, GameDomainModel, Interactor<Int, [GameDomainModel], GetFavoriteRepository<GetFavoriteLocaleDataSource, FavoriteListTransformer>>>

  var body: some View {
    TabView {
      NavigationStack {
        HomeView(listPresenter: homePresenter, searchPresenter: searchPresenter)
      }.tabItem {
        TabItem(imageName: "house", title: "Home")
      }

      NavigationStack {
        FavoriteView(presenter: favoritePresenter)
      }.tabItem {
        TabItem(imageName: "heart.fill", title: "Favorite")
      }

      NavigationStack {
        ProfileView()
      }.tabItem {
        TabItem(imageName: "person", title: "Profile")
      }
    }
  }
}
