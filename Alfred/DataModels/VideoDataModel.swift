//
//  VideoDataModel.swift
//  Alfred
//
//  Created by John Pillar on 14/08/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct VideoDataItem: Codable {
    let stream: String?

    init(stream: String? = nil) {
        self.stream = stream
    }
}

public class VideoData: ObservableObject {

    @Published var image: UIImage?
    @Published var videoURL: String?

    private var loadingVideo: Bool = false
    private var videoDataItem: VideoDataItem = VideoDataItem() {
        didSet {
            videoURL = videoDataItem.stream
        }
    }
    private(set) var cancellationToken: AnyCancellable?

    deinit {
        cancellationToken?.cancel()
    }
}

extension VideoData {

    @objc func getImage(camera: String) {
        let (urlRequest, errorURL) = getAlfredData(for: "hls/camera/\(camera)/image")
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
                .map { UIImage(data: $0.data) }
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .catch { error -> AnyPublisher<UIImage?, Never> in
                    print("☣️ getImage - error: \(error)")
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
                .assign(to: \.image, on: self)
        }
    }

    @objc func getVideo(camera: String) {
        if loadingVideo { return }
        let (urlRequest, errorURL) = getAlfredData(for: "hls/camera/\(camera)/stream")
        if errorURL == nil {
            loadingVideo = true
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
                .map { $0.data }
                .decode(type: VideoDataItem.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .catch { error -> AnyPublisher<VideoDataItem, Never> in
                    print("☣️ getVideo - error decoding: \(error)")
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
                .assign(to: \.videoDataItem, on: self)
        }
    }

    func cancel() {
        cancellationToken?.cancel()
    }
}
