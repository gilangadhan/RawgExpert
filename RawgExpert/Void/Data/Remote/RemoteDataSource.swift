import Foundation
import Combine
import Alamofire

protocol RemoteDataSourceProtocol: AnyObject {
  func getGames() -> AnyPublisher<[GameResponse], Error>
  func getGame(by id: Int) -> AnyPublisher<GameDetailResponse, Error>
  func search(by name: String) -> AnyPublisher<[GameResponse], Error>
}

final class RemoteDataSource: NSObject {
  private override init() {  }
  static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {

  func getGames() -> AnyPublisher<[GameResponse], Error> {
    return Future<[GameResponse], Error> { result in
      guard let url = URL(string: Endpoints.Gets.games.url) else { return }
      AF.request(url)
        .validate()
        .responseDecodable(of: GamesResponse.self) { response in
          switch response.result {
          case .success(let value):
            result(.success(value.results))
          case .failure:
            result(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }

  func getGame(by id: Int) -> AnyPublisher<GameDetailResponse, Error> {
    return Future<GameDetailResponse, Error> { result in
      guard let url = URL(string: Endpoints.Gets.gameById(id).url) else { return }
      AF.request(url)
        .validate()
        .responseDecodable(of: GameDetailResponse.self) { response in
          switch response.result {
          case .success(let value):
            result(.success(value.self))
          case .failure:
            result(.failure(URLError.invalidResponse))
          }
        }
    }
    .eraseToAnyPublisher()
  }

  func search(by name: String) -> AnyPublisher<[GameResponse], Error> {
    return Future<[GameResponse], Error> { result in
      guard let url = URL(string: Endpoints.Gets.search.url + name) else { return }
      AF.request(url)
        .validate()
        .responseDecodable(of: GamesResponse.self) { response in
          switch response.result {
          case .success(let value):
            result(.success(value.results))
          case .failure:
            result(.failure(URLError.invalidResponse))
          }
        }
    }
    .eraseToAnyPublisher()
  }
}
