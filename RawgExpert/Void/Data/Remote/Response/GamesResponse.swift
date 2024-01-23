import Foundation

struct GamesResponse: Decodable {
  let results: [GameResponse]
}

struct GameResponse: Decodable {

  let id: Int
  let title: String
  let image: String
  let releasedDate: String
  let rating: Double

  private enum CodingKeys: String, CodingKey {
    case id, rating
    case image = "background_image"
    case releasedDate = "released"
    case title = "name"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.image = try container.decode(String.self, forKey: .image)
    self.title = try container.decode(String.self, forKey: .title)
    self.rating = try container.decode(Double.self, forKey: .rating)
    self.releasedDate = try container.decode(String.self, forKey: .releasedDate)
  }
}
