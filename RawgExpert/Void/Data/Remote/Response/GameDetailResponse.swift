import Foundation

struct GameDetailResponse: Decodable {
  let id: Int
  let title: String
  let image: String
  let releasedDate: String
  let rating: Double
  let backgroundImage: String
  let description: String

  enum CodingKeys: String, CodingKey {
    case id, rating, description
    case title = "name"
    case releasedDate = "released"
    case image = "background_image"
    case backgroundImage = "background_image_additional"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.rating = try container.decode(Double.self, forKey: .rating)
    self.title = try container.decode(String.self, forKey: .title)
    self.image = try container.decode(String.self, forKey: .image)
    self.backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
    self.releasedDate = try container.decode(String.self, forKey: .releasedDate)

    let desc = try container.decode(String.self, forKey: .description)
    self.description = desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}
