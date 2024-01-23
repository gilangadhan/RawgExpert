import Foundation

final class GameMapper {

  static func mapGameResponsesToEntities(
    input gameResponse: [GameResponse]
  ) -> [GameEntity] {
    return gameResponse.map { result in
      let newGames = GameEntity()
      newGames.id = result.id
      newGames.title = result.title
      newGames.image = result.image
      newGames.rating = result.rating
      newGames.releasedDate = result.releasedDate
      return newGames
    }
  }

  static func mapGameEntitiesToDomains(
    input gameEntities: [GameEntity]
  ) -> [GameModel] {
    return gameEntities.map { result in
      return GameModel(
        id: result.id,
        title: result.title,
        image: result.image,
        releasedDate: result.releasedDate,
        rating: result.rating,
        backgroundImage: result.backgroundImage,
        descriptions: result.descriptions,
        isFavorite: result.isFavorite
      )
    }
  }

  static func mapGameDetailResponsesToEntity(
    by id: Int,
    input result: GameDetailResponse
  ) -> GameEntity {
    let gameEntity = GameEntity()
    gameEntity.id = result.id
    gameEntity.title = result.title
    gameEntity.image = result.image
    gameEntity.releasedDate = result.releasedDate
    gameEntity.rating = result.rating
    gameEntity.backgroundImage = result.backgroundImage
    gameEntity.descriptions = result.description
    return gameEntity
  }

  static func mapDetailEntityToDomain(
    input gameEntity: GameEntity
  ) -> GameModel {
    return GameModel(
      id: gameEntity.id,
      title: gameEntity.title,
      image: gameEntity.image,
      releasedDate: gameEntity.releasedDate,
      rating: gameEntity.rating,
      backgroundImage: gameEntity.backgroundImage,
      descriptions: gameEntity.descriptions,
      isFavorite: gameEntity.isFavorite)
  }

  static func mapDetailResponseToEntity(
    input gameResponse: [GameResponse]
  ) -> [GameEntity] {
    return gameResponse.map { result in
      let gameEntity = GameEntity()
      gameEntity.id = result.id
      gameEntity.title = result.title
      gameEntity.image = result.image
      gameEntity.rating = result.rating
      gameEntity.releasedDate = result.releasedDate
      return gameEntity
    }
  }
}
