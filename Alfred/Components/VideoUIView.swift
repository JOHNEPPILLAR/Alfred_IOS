//
//  VideoUIView.swift
//  Alfred
//
//  Created by John Pillar on 13/08/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerView>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController,
                                context: UIViewControllerRepresentableContext<PlayerView>) {
        return
    }
}

struct VideoUIView: View {

    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var videoData: VideoData = VideoData()
    @State var showVideo: Bool = false

    private let player: AVPlayer
    init(player: AVPlayer) {
        self.player = player
    }

    var body: some View {
        VStack {
            VStack {
                if videoData.videoURL != nil {
                    VStack {
                        ZStack {
                            PlayerView(player: player)
                                .onAppear {
                                    let (url, errorURL) = videoURL(url: videoData.videoURL ?? "")
                                    if errorURL == nil {
                                        player.replaceCurrentItem(with: AVPlayerItem(url: url!))
                                        player.play()
                                    }
                                }
                                .onDisappear {
                                    player.pause()
                                }
                        }
                    }
                } else {
                    VStack {
                        ZStack {
                            Image(uiImage: videoData.image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .onAppear {
                                    videoData.getImage(camera: stateSettings.camera)
                                }
                                .onDisappear(perform: videoData.cancel)
                                .cornerRadius(10)
                            // swiftlint:disable multiple_closures_with_trailing_closure
                            Button(action: {
                                videoData.getVideo(camera: stateSettings.camera)
                                self.showVideo = true
                            }) {
                                if showVideo {
                                    ActivityIndicator(isAnimating: true)
                                        .configure { $0.color = .white }
                                } else {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .disabled(showVideo)
                            .frame(width: 30, height: 30)
                            .background(Color.black)
                            .cornerRadius(5)
                        }
                    }
                }
            }
            .padding(10)
            .background(Color.black)
            .cornerRadius(15)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 160)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

#if DEBUG
struct VideoUIView_Previews: PreviewProvider {

    static var previews: some View {
        let stateSettings = StateSettings()
        stateSettings.currentMenuItem = 1

        return ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VideoUIView(player: AVPlayer())
                .environmentObject(stateSettings)
        }
    }
}
#endif
