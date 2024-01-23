import SwiftUI
import Combine
import Games

class HomePresenter: ObservableObject {

  private let router = HomeRouter()
  private let homeUseCase: HomeUseCase
  private let searchUseCase: SearchUseCase
  private var cancellables: Set<AnyCancellable> = []

  @Published var games: [GameModel] = []
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""

  init(homeUseCase: HomeUseCase, searchUseCase: SearchUseCase) {
    self.homeUseCase = homeUseCase
    self.searchUseCase = searchUseCase
  }

  func getGames() {
    isLoading = true
    homeUseCase.getGames()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { games in
        self.games = games
      })
      .store(in: &cancellables)
  }

  func search() {
    isLoading = true
    searchUseCase.search(by: searchText)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          self.isLoading = false
        case .finished:
          self.isLoading = false
        }
      }, receiveValue: { games in
        self.games = []
        self.games = games
      })
      .store(in: &cancellables)
  }

  func linkBuilder<Content: View>(
    for game: GameDomainModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(destination: router.makeDetailView(for: game)) { content() }
  }
}
