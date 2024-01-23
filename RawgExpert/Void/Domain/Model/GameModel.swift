import Foundation

struct GameModel: Equatable, Identifiable {
  let id: Int
  let title: String
  let image: String
  let releasedDate: String
  let rating: Double
  let backgroundImage: String
  let descriptions: String
  var isFavorite: Bool = false
}
