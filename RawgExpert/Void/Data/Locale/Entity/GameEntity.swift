import Foundation
import RealmSwift

class GameEntity: Object {

  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var image: String = ""
  @objc dynamic var releasedDate: String = ""
  @objc dynamic var rating: Double = 0.0
  @objc dynamic var backgroundImage: String = ""
  @objc dynamic var descriptions: String = ""
  @objc dynamic var isFavorite: Bool = false

  override class func primaryKey() -> String? {
    return "id"
  }
}
