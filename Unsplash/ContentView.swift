import SwiftUI

struct ContentView: View {
    @State private var imageURL: URL?
    @State private var image: UIImage?

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading...")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            fetchRandomImage()
        }
        .onReceive(timer) { _ in
            fetchRandomImage()
        }
    }

    private func fetchRandomImage() {
        UnsplashAPI.randomPhotoURL { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                imageURL = url
                loadImage()
            }
        }
    }

    private func loadImage() {
        guard let imageURL = imageURL else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    image = uiImage
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
