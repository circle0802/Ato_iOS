//
//  AtoRemoteImage.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import SwiftUI
import UIKit
import Combine

struct AtoRemoteImage<Placeholder: View>: View {
    let urlString: String
    let fallbackURLStrings: [String]
    let contentMode: ContentMode
    @ViewBuilder let placeholder: Placeholder

    @StateObject private var loader = AtoRemoteImageLoader()

    init(
        urlString: String,
        fallbackURLStrings: [String] = [],
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.urlString = urlString
        self.fallbackURLStrings = fallbackURLStrings
        self.contentMode = contentMode
        self.placeholder = placeholder()
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder
            }
        }
        .task(id: urlString + fallbackURLStrings.joined()) {
            await loader.load(from: [urlString] + fallbackURLStrings)
        }
    }
}

@MainActor
private final class AtoRemoteImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var loadedURLStrings: [String] = []

    func load(from urlStrings: [String]) async {
        let candidateURLStrings = orderedCandidateURLStrings(from: urlStrings)

        guard loadedURLStrings != candidateURLStrings else {
            return
        }

        loadedURLStrings = candidateURLStrings
        image = nil

        for urlString in candidateURLStrings {
            guard let url = makeURL(from: urlString) else {
                continue
            }

            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            request.setValue(
                "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
                forHTTPHeaderField: "User-Agent"
            )
            request.setValue("image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8", forHTTPHeaderField: "Accept")

            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode),
                    let image = UIImage(data: data)
                else {
                    continue
                }

                self.image = image
                return
            } catch {
                continue
            }
        }

        self.image = nil
    }

    private func makeURL(from urlString: String) -> URL? {
        let trimmedURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        if let url = URL(string: trimmedURLString) {
            return url
        }

        return trimmedURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap(URL.init(string:))
    }

    private func orderedCandidateURLStrings(from urlStrings: [String]) -> [String] {
        let uniqueURLStrings = urlStrings.reduce(into: [String]()) { result, urlString in
            let trimmedURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedURLString.isEmpty, !result.contains(trimmedURLString) else {
                return
            }

            result.append(trimmedURLString)
        }

        let unstableURLStrings = uniqueURLStrings.filter { isUnstableImageURLString($0) }
        let stableURLStrings = uniqueURLStrings.filter { !isUnstableImageURLString($0) }

        return stableURLStrings + unstableURLStrings
    }

    private func isUnstableImageURLString(_ urlString: String) -> Bool {
        guard let host = makeURL(from: urlString)?.host else {
            return false
        }

        return host == "source.unsplash.com"
    }
}
