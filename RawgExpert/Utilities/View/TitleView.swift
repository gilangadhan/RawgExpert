import SwiftUI

struct TitleView: View {
  var title: String
  var body: some View {
    HStack {
      VStack(alignment: .leading, content: {
        Text(title)
          .font(.title)
      })
      .padding(.horizontal)
      Spacer()
    }
    Spacer()
  }
}

#Preview {
  TitleView(title: "Favorite Games")
}
