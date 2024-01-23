import SwiftUI

struct SearchView: View {

  @Binding var search: String

  var body: some View {

    VStack(alignment: .leading) {
      Text("Choose")
        .fontWeight(.medium)
      Text("your game")
        .font(.headline)
        .fontWeight(.heavy)
      TextField(
        "",
        text: $search,
        prompt: Text("\(Image(systemName: "magnifyingglass")) Search games...")
          .foregroundStyle(.gray)
      )
      .autocorrectionDisabled(true)
      .padding(8)
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.white)
      )
      Text("Top Games")
        .font(.system(size: 25, weight: .heavy, design: .rounded))
        .padding(.top)
    }
    .padding(.horizontal)
    .background(Color.searchColor)
  }
}
