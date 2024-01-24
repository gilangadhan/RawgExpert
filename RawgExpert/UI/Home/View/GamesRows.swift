import SwiftUI
import Core
import Games

struct GamesRows: View {

  var game: GameDomainModel

  var body: some View {
    HStack {
      showImage
      showContent
    }
    .frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
    .padding(.horizontal)
  }
}

extension GamesRows {

  var showImage: some View {
    AsyncImage(url: URL(string: game.image)) { image in
      image.image?.resizable()
        .aspectRatio(contentMode: .fill)
    }
    .frame(width: 70, height: 70)
    .cornerRadius(10)
  }

  var showContent: some View {
    VStack(
      alignment: .leading
    ) {
        Text(game.title)
          .font(Font.system(size: 16))
          .fontWeight(.bold)
        Text("\(Image(systemName: "calendar")) \(game.releasedDate)")
          .font(Font.system(size: 12))
        Text("\(Image(systemName: "star")) \(game.rating, specifier: "%.2f")")
          .font(Font.system(size: 12))
      }
  }
}
