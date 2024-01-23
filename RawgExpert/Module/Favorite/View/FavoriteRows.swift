import SwiftUI
import Games

struct FavoriteRows: View {

  var favorites: GameDomainModel

  var body: some View {
    HStack {
      showImage
      showContent
    }
    .frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
    .padding(.horizontal)
  }
}

extension FavoriteRows {

  var showImage: some View {
    AsyncImage(url: URL(string: favorites.image)) { image in
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
        Text(favorites.title)
          .font(Font.system(size: 16))
          .fontWeight(.bold)
        Text("\(Image(systemName: "calendar")) \(favorites.releasedDate)")
          .font(Font.system(size: 12))
        Text("\(Image(systemName: "star")) \(favorites.rating, specifier: "%.2f")")
          .font(Font.system(size: 12))
      }
  }
}
