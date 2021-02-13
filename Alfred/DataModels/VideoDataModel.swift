//
//  VideoDataModel.swift
//  Alfred
//
//  Created by John Pillar on 14/08/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - VideoDataItem
struct VideoDataItem: Codable {
  let stream: String?

  init(stream: String? = nil) {
    self.stream = stream
  }
}

// MARK: - CameraStatusDataItem
struct CameraStatusDataItem: Codable {
  let isPrivacyEnabled: Bool?

  init(isPrivacyEnabled: Bool? = nil) {
    self.isPrivacyEnabled = isPrivacyEnabled
  }
}

// MARK: - VideoData class
public class VideoData: ObservableObject {

  @Published var privacyStatus: Bool? = false
  @Published var image: UIImage?
  @Published var videoUrl: URL?
  @Published var showVideo: Bool? = false
  @Published var apiError: Bool? = false

  private let errorImage = UIImage(named: "image_unavailable")
  private var loadingVideo: Bool = false
  private var videoDataItem: VideoDataItem = VideoDataItem() {
    didSet {
      do {
        videoUrl = try getVideoURL(url: videoDataItem.stream ?? "")
      } catch {
        print("☣️", error.localizedDescription)
        self.apiError = true
      }
    }
  }
}

// MARK: - VideoData extension
extension VideoData {

  @objc func getPrivacyStatus(camera: String) {
    callAlfredService(from: "hls/camera/\(camera)/privacystatus", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode(CameraStatusDataItem.self, from: data)
          self.privacyStatus = decodedData.isPrivacyEnabled
        } catch {
          print("☣️ JSONSerialization error:", error)
          self.apiError = true
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
        self.apiError = true
      }
    }
  }

  @objc func getImage(camera: String) {
    callAlfredService(from: "hls/camera/\(camera)/image", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        self.image = UIImage(data: data)
      case .failure(let error):
        print("☣️", error.localizedDescription)
        self.apiError = true
      }
    }
  }

  @objc func getVideo(camera: String) {
    if loadingVideo { return }
    callAlfredService(from: "hls/camera/\(camera)/stream", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode(VideoDataItem.self, from: data)
          self.loadingVideo = false
          self.videoDataItem = decodedData
        } catch {
          print("☣️ JSONSerialization error:", error)
          self.loadingVideo = false
          self.apiError = true
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
        self.loadingVideo = false
        self.apiError = true
      }
    }
  }
}
