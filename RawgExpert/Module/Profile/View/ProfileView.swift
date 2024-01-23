//
//  ProfileView.swift
//  RawgExpert
//
//  Created by Farid Firda Utama on 16/01/24.
//

import SwiftUI

struct ProfileView: View {
  var body: some View {
    ZStack {
      Color(Color.profileColor)
        .ignoresSafeArea(edges: .top)
      VStack(alignment: .center) {
        Spacer()
        AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/48374273?v=4")) { image in
          image.image?.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
        }
        Text("Farid Firda Utama")
          .font(Font.custom("Pacifico-Regular", size: 35))
          .bold()
          .foregroundColor(.white)
        Text("iOS Developer")
          .font(.system(size: 30))
          .foregroundColor(.white)
          .fontWeight(.medium)
        Divider()
        InfoView(text: "0813 8948 3864", imageName: "phone.fill")
        InfoView(text: "dadit.utama@gmail.com", imageName: "envelope.fill")
        Spacer()
      }
      .padding()
    }
  }
}

struct InfoView: View {

  let text: String
  let imageName: String

  var body: some View {
    RoundedRectangle(cornerRadius: 25)
      .fill(.black)
      .opacity(0.1)
      .frame(height: 50)
      .overlay(HStack {
        Image(systemName: imageName)
          .foregroundColor(.white)
        Text(text)
          .font(.headline)
          .foregroundStyle(.white)
      })
      .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 2))
  }
}

#Preview {
  ProfileView()
}
