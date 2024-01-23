//import SwiftUI
//import Combine
//
//class FavoritePresenter: ObservableObject {
//
//  private var router = FavoriteRouter()
//  private var favoriteUseCase: FavoriteUseCase
//  private var cancellables: Set<AnyCancellable> = []
//
//  @Published var favorites: [GameModel] = []
//  @Published var errorMessage: String = ""
//  @Published var isLoading: Bool = false
//
//  init(favoriteUseCase: FavoriteUseCase) {
//    self.favoriteUseCase = favoriteUseCase
//  }
//
//  func getFavorite() {
//    isLoading = true
//    favoriteUseCase.getFavorite()
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .finished:
//          self.isLoading = false
//        case .failure(let error):
//          self.errorMessage = error.localizedDescription
//        }
//      }, receiveValue: { fav in
//        self.favorites = fav
//      })
//      .store(in: &cancellables)
//  }
//
//  func linkBuilder<Content: View>(
//    for fav: GameModel,
//    @ViewBuilder content: () -> Content
//  ) -> some View {
//    NavigationLink(destination: router.makeFavoriteView(for: fav)) { content() }
//  }
//}
