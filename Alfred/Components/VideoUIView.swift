//
//  VideoUIView.swift
//  Alfred
//
//  Created by John Pillar on 13/08/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import AVKit
import iActivityIndicator

struct VideoUIView: View {

    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var videoData: VideoData = VideoData()

    @State var showVideo: Bool = false
    @State var apiError: Bool = false
    @State var camImage: UIImage = UIImage()
    @State var loading: Bool = false

    private let player = AVPlayer()

    var body: some View {
        VStack {
            VStack {
                if apiError {
                    VStack {
                        Image(uiImage: UIImage(named: "image_unavailable")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .cornerRadius(10)
                    }
                } else {
                    if showVideo {
                        VStack {
                            VideoPlayer(player: player)
                            .onDisappear {
                                player.pause()
                            }
                        }
                    } else {
                        VStack {
                            ZStack {
                                Image(uiImage: camImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .onAppear {
                                        videoData.getImage(camera: stateSettings.camera)
                                        loading = true
                                    }
                                    .onReceive(videoData.$image) { image in
                                        if !(image == nil) {
                                            camImage = image!
                                            loading = false
                                        }
                                    }
                                    .cornerRadius(10)
                                // swiftlint:disable multiple_closures_with_trailing_closure
                                Button(action: {
                                    videoData.getVideo(camera: stateSettings.camera)
                                    loading = true
                                }) {
                                    if loading {
                                        iActivityIndicator(style: .rotatingShapes(size: 5))
                                            .foregroundColor(.gray)
                                    } else {
                                        Image(systemName: "play")
                                            .foregroundColor(.white)
                                    }
                                }
                                .disabled(showVideo)
                                .frame(width: 40, height: 40)
                                .background(Color.black)
                                .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .onReceive(videoData.$apiError) { newStatus in
                self.apiError = newStatus ?? false
                loading = false
            }
            .onReceive(videoData.$videoUrl) { videoUrl in
                if !(videoUrl == nil) {
                    loading = false
                    player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl!))
                    player.play()
                    showVideo = true
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
        stateSettings.currentMenuItem = 0

        return ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VideoUIView()
                .environmentObject(stateSettings)
        }
    }
}
#endif
