import SwiftUI
import Core
import Games
import Detail
import Favorite

struct DetailView: View {

  @ObservedObject var presenter: DetailPresenter<
    Interactor<
      Int, GameDomainModel, GetDetailRepository<
        GetDetailLocaleDataSource, GetDetailRemoteDataSource, DetailTransformer
      >
    >,
    Interactor<
      Int, GameDomainModel, UpdateFavoriteRepository<
        GetFavoriteLocaleDataSource, FavoriteTransformer
      >
    >
  >

  var detail: GameDomainModel

  var body: some View {
    ZStack {
      if presenter.isLoading {
        loadingIndicator
      } else {
        showDetail
      }
    }
    .onAppear {
      self.presenter.getDetail(request: detail.id)
    }
  }
}

extension DetailView {
  var loadingIndicator: some View {
    VStack {
      Text("Now loading")
      ProgressView()
    }
  }

  var showDetail: some View {
    ScrollView(.vertical) {
      VStack {
        AsyncImage(url: URL(string: detail.backgroundImage)) { image in
          image.image?.resizable()
            .aspectRatio(contentMode: .fit)
        }
        .overlay(
          AsyncImage(url: URL(string: detail.image)) { image in
            image.image?.resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: 200)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(Color.white)
              )
          }.opacity(0.6)
        )

        HStack {
          RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
            .frame(width: 90, height: 30)
            .overlay(HStack {
              Text("\(detail.rating, specifier: "%.2f")")
                .font(.system(size: 16, design: .rounded))
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            })
          Spacer()
          RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
            .frame(width: 130, height: 30)
            .overlay(HStack {
              Text("\(detail.releasedDate)")
                .font(.system(size: 16, design: .rounded))
              Image(systemName: "calendar")
                .foregroundStyle(.secondary)
            })
        }
        .padding(.horizontal)

        Text(detail.title)
          .font(Font.system(size: 26, design: .rounded))
          .fontWeight(.bold)
          .padding()

        VStack(alignment: .leading) {
          Text("About")
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
          ScrollView {
            Text(presenter.detail?.descriptions ?? "No Description")
              .font(.system(size: 14, design: .rounded))
              .lineLimit(nil)
              .fontWeight(.medium)
          }
        }
        .safeAreaPadding(.bottom)
        .padding(.horizontal)
      }
    }
    .toolbar {
      Button {
        if self.presenter.detail?.isFavorite == true {
          self.presenter.updateFavorite(request: detail.id)
        } else {
          self.presenter.updateFavorite(request: detail.id)
        }
      } label: {
        Label("Favorite", systemImage: presenter.detail?.isFavorite == true ? "heart.fill" : "heart")
          .foregroundStyle(.red)
      }
    }
  }
}
