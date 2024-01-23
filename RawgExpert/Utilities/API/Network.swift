import Foundation
import Alamofire
import Combine

struct API {
  static let baseUrl = "https://api.rawg.io/api/"
}

protocol EndPoint {
  var url: String { get }
}

enum Endpoints {

  enum Gets: EndPoint {
    case games
    case gameById(_ id: Int)
    case search

    private var apiKey: String {
      guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
        fatalError("Couldn't find file 'Info.plist'.")
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'RawgExpert-Info.plist'.")
      }
      return "?key=\(value)"
    }

    public var url: String {

      switch self {
      case .games: return "\(API.baseUrl)games\(apiKey)"
      case .gameById(let id): return "\(API.baseUrl)games/\(id)\(apiKey)"
      case .search: return "\(API.baseUrl)games\(apiKey)&search="
      }
    }
  }
}
