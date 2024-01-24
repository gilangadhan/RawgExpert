import SwiftUI
import Core
import Games
import Detail
import Favorite

class FavoriteRouter {

  func makeDetailFavoriteView(for fav: GameDomainModel) -> some View {
    let detailUseCase: Interactor<
      Int, GameDomainModel, GetDetailRepository<
        GetDetailLocaleDataSource, GetDetailRemoteDataSource, DetailTransformer>
    > = DependencyInjection.init().provideDetail(detail: fav)

    let favoriteUseCase: Interactor<
      Int, GameDomainModel, UpdateFavoriteRepository<
        GetFavoriteLocaleDataSource, FavoriteTransformer>
    > = DependencyInjection.init().provideUpdateFavorite()

    let presenter = DetailPresenter(detailUseCase: detailUseCase, favoriteUseCase: favoriteUseCase)

    return DetailView(presenter: presenter, detail: fav)
  }
}
