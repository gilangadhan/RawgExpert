import SwiftUI
import Core
import Games
import Favorite

struct FavoriteView: View {

  @ObservedObject var presenter: FavoritePresenter<
    Int, GameDomainModel, Interactor<
      Int, [GameDomainModel], GetFavoriteRepository<
        GetFavoriteLocaleDataSource, FavoriteListTransformer>>>

  var body: some View {
    ZStack {
      if presenter.isLoading {
        loadingIndicator
      } else if presenter.list.isEmpty {
        emptyFavorites
      } else {
        listFavorites
      }
    }
    .onAppear {
      self.presenter.getFavoriteList(request: nil)
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension FavoriteView {

  var loadingIndicator: some View {
    VStack {
      Text("Now loading")
      ProgressView()
    }
  }

  var emptyFavorites: some View {
    VStack {
      Image(systemName: "rectangle.and.text.magnifyingglass")
        .resizable()
        .renderingMode(.original)
        .scaledToFit()
        .frame(width: 70)

      Text("You have no Favorite Games")
        .font(.system(.body, design: .rounded))
    }
  }

  var listFavorites: some View {
    ScrollView(.vertical, showsIndicators: false) {
      TitleView(title: "Favorite Games")
      ForEach(
        self.presenter.list,
        id: \.id
      ) { fav in
        ZStack {
          linkBuilder(for: fav) {
            FavoriteRows(favorites: fav)
          }.buttonStyle(PlainButtonStyle())
        }
      }
    }
  }

  func linkBuilder<Content: View>(
    for favorite: GameDomainModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: FavoriteRouter().makeDetailFavoriteView(for: favorite)
    ) { content() }
  }
}
