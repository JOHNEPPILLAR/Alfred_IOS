//
//  Notifications.swift
//  Alfred
//
//  Created by John Pillar on 30/01/2021.
//  Copyright © 2021 John Pillar. All rights reserved.
//
import Foundation
import UIKit
import UserNotifications

// MARK: - NotificationSaveDataItem
struct NotificationSaveDataItem: Codable {
  let state: String?

  init(state: String? = nil) {
    self.state = state
  }
}

// MARK: - NotificationDataItem
struct NotificationDataItem: Codable {
  let id, time, notification: String?
  let unRead: Bool?

  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case time, notification, unRead
  }

  init(id: String? = nil, time: String? = nil, notification: String? = nil, unRead: Bool? = nil) {
    self.id = id
    self.time = time
    self.notification = notification
    self.unRead = unRead
  }
}

// MARK: - NotificationData class
public class NotificationData: ObservableObject {
  @Published var results: [NotificationDataItem] = [NotificationDataItem]()

  private var saved: NotificationSaveDataItem = NotificationSaveDataItem() {
    didSet {
      self.loadData()
    }
  }

  init() {
    loadData()
  }
}

// MARK: - NeedsWaterData extension
extension NotificationData {
  func loadData() {
    callAlfredService(from: "health/notifications", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([NotificationDataItem].self, from: data)
          self.results = decodedData
          UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (granted, _) in
            if granted {
              DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = self.results.count
              }
            }
          }
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }

  func markAsRead(id: String) {
    callAlfredService(from: "health/notifications/" + id, httpMethod: "PUT") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode(NotificationSaveDataItem.self, from: data)
          self.saved = decodedData
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }
}
