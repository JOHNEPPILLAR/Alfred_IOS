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

struct AVPlayerView: UIViewControllerRepresentable {

  @Binding var videoURL: URL?

  private var player: AVPlayer {
    return AVPlayer(url: videoURL!)
  }

  func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
  }

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let playerController = AVPlayerViewController()
    playerController.player = self.player
    playerController.videoGravity = .resizeAspectFill
    playerController.player?.preventsDisplaySleepDuringVideoPlayback = true
    playerController.player?.play()
    return playerController
  }
}

struct VideoUIView: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var videoData: VideoData = VideoData()

  @State private var loading: Bool = true
  @State private var privacyStatus: Bool = false
  @State private var apiError: Bool = false
  @State private var camImage: UIImage = UIImage()
  @State private var loadVideo: Bool = false
  @State private var videoReady: Bool = false
  @State private var videoURL: URL!

  private let player = AVPlayer()

  var body: some View {
    VStack {
      if apiError {
        VStack {
          Image(uiImage: UIImage(named: "image_unavailable")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .cornerRadius(10)
            .onAppear {
              loading = false
            }
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(15)
      } else if privacyStatus {
        VStack {
          Image(uiImage: UIImage(named: "cam_privacy")!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .cornerRadius(10)
            .onAppear {
              loading = false
            }
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(15)
      } else if videoReady {
        AVPlayerView(videoURL: $videoURL)
          .padding(10)
          .background(Color.black)
          .cornerRadius(15)
      } else {
        ZStack {
          Image(uiImage: camImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .onAppear {
              loading = true
              videoData.getPrivacyStatus(camera: stateSettings.camera)
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
            self.loadVideo.toggle()
            if loadVideo {
              loading = true
              videoData.getVideo(camera: stateSettings.camera)
            }
          }) {
            if loading {
              Indicator.Continuous(isAnimating: loading, color: .white)
            } else {
              Image(systemName: "play")
                .foregroundColor(.green)
                .font(.system(size: 40))
            }
          }
          .frame(width: 40, height: 40)
          .cornerRadius(5)
        }
        .onReceive(videoData.$apiError) { newStatus in
          self.apiError = newStatus ?? false
        }
        .onReceive(videoData.$privacyStatus) { newStatus in
          if !(newStatus == nil) {
            self.privacyStatus = newStatus!
              if !(newStatus!) {
                videoData.getImage(camera: stateSettings.camera)
              }
          }
        }
        .onReceive(videoData.$videoUrl) { videoUrl in
          if !(videoUrl == nil) {
            self.videoURL = videoUrl
            self.videoReady = true
          }
        }
        .padding(10)
        .background(Color.black)
        .cornerRadius(15)
      }
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
