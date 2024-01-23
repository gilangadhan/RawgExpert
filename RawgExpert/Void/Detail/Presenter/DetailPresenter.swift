//import Foundation
//import Combine
//
//class DetailPresenter: ObservableObject {
//
//  private let detailUseCase: DetailUseCase
//  private var cancellables: Set<AnyCancellable> = []
//
//  @Published var detail: GameModel
//  @Published var errorMessage: String = ""
//  @Published var isLoading: Bool = false
//
//  init(detailUseCase: DetailUseCase) {
//    self.detailUseCase = detailUseCase
//    detail = detailUseCase.getGame()
//  }
//
//  func getGame() {
//    isLoading = true
//    detailUseCase.getGame()
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure(let error):
//          self.errorMessage = error.localizedDescription
//          self.isLoading = false
//        case .finished:
//          self.isLoading = false
//        }
//      }, receiveValue: { detail in
//        self.detail = detail
//      })
//      .store(in: &cancellables)
//  }
//
//  func updateFavorite() {
//    detailUseCase.updateFavorite()
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .finished:
//          self.isLoading = false
//        case .failure:
//          self.errorMessage = String(describing: completion)
//        }
//      }, receiveValue: { fav in
//        self.detail = fav
//      })
//      .store(in: &cancellables)
//  }
//}
