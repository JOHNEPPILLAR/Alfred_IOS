//
//  VideoUIView.swift
//  Alfred
//
//  Created by John Pillar on 13/08/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import AVKit
import ActivityIndicators

struct VideoFullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var videoData: VideoData = VideoData()
    @State var apiError: Bool = false
    @State var showVideo: Bool = false

    private let player = AVPlayer()

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            VStack {
                if apiError {
                ZStack {
                    VStack {
                        Image(uiImage: UIImage(named: "image_unavailable")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 160)
                            .cornerRadius(10)
                    }
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(15)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 160)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                } else {
                    if showVideo {
                        VStack {
                            HStack {
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding(10)
                            VideoPlayer(player: player)
                        }.background(Color.black)
                    .onDisappear {
                        player.pause()
                    }
                    } else {
                    ZStack {
                        VStack {
                            Indicator.Continuous(isAnimating: !showVideo, color: .white)
                            .onAppear {
                                videoData.getVideo(camera: stateSettings.camera)
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(videoData.$videoUrl) { videoUrl in
                if !(videoUrl == nil) {
                    self.showVideo = true
                    player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl!))
                    player.play()
                    player.preventsDisplaySleepDuringVideoPlayback = true
                }
            }
            .onReceive(videoData.$apiError) { newStatus in
                self.apiError = newStatus ?? false
                showVideo = false
            }
        }
    }
}

struct VideoUIView: View {

    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var videoData: VideoData = VideoData()

    @State var showVideo: Bool = false
    @State var apiError: Bool = false
    @State var camImage: UIImage = UIImage()
    @State var loading: Bool = false

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
                                self.showVideo.toggle()
                            }) {
                                if !showVideo {
                                    Image(systemName: "play")
                                        .foregroundColor(.green)
                                        .font(.system(size: 40))
                                }
                            }
                            //.disabled(showVideo)
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .fullScreenCover(isPresented: $showVideo, content: VideoFullScreenModalView.init)
                        }
                    }
                }
            }
            .onReceive(videoData.$apiError) { newStatus in
                self.apiError = newStatus ?? false
                loading = false
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
