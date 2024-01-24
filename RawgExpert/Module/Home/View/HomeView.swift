import SwiftUI
import Core
import Games

struct HomeView: View {

  @ObservedObject var listPresenter: GetListPresenter<Any, GameDomainModel, Interactor<Any, [GameDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>>

  @ObservedObject var searchPresenter: SearchPresenter<GameDomainModel, Interactor<String, [GameDomainModel], SearchRepository<GetSearchLocaleDataSource, GetSearchRemoteDataSource, SearchTransformer>>>

  var body: some View {
    ZStack {
      Color(Color.searchColor)
        .ignoresSafeArea(.all)
      VStack {
        SearchView(search: self.$searchPresenter.searchText)
          .onChange(of: self.searchPresenter.searchText) {
            if self.searchPresenter.searchText.isEmpty {
              self.listPresenter.getList(request: nil)
            } else {
              self.searchPresenter.search()
              listPresenter.list = searchPresenter.list
            }
          }
        listGames
      }
    }
    .onAppear {
      if self.listPresenter.list.count == 0 {
        self.listPresenter.getList(request: nil)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension HomeView {

  var loadingIndicator: some View {
    VStack {
      Text("Now loading")
      ProgressView()
    }
  }

  var emptyGames: some View {
    VStack {
      Image(systemName: "rectangle.and.text.magnifyingglass")
        .resizable()
        .renderingMode(.original)
        .scaledToFit()
        .frame(width: 70)

      Text("No Games")
        .font(.system(.body, design: .rounded))
    }
  }

  var listGames: some View {
    ScrollView(.vertical, showsIndicators: false) {
      if listPresenter.isLoading {
        loadingIndicator
      } else if listPresenter.list.isEmpty {
        emptyGames
      } else {
        ForEach(
          self.listPresenter.list,
          id: \.id
        ) { game in
          ZStack {
            linkBuilder(for: game) {
              GamesRows(game: game)
            }.buttonStyle(PlainButtonStyle())
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .background(.white)
  }

  func linkBuilder<Content: View>(
    for detail: GameDomainModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: HomeRouter().makeDetailView(for: detail)
    ) { content() }
  }
}
