//
//  AlfredApp.swift
//  Alfred
//
//  Created by John Pillar on 15/11/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

}

@available(iOS 13.0, *)
func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

}

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  // swiftlint:disable colon line_length
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    registerForPushNotifications()
    return true
  }

  func registerForPushNotifications() {
    UNUserNotificationCenter.current()
    .requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] granted, error in
      if let error = error {
        print("Error: \(error)")
        return
      }
      print("Permission granted: \(granted)")
      guard granted else { return }
      self?.getNotificationSettings()
    }
  }

  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  func decreaseBadgeCount() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.applicationIconBadgeNumber -= 1
      }
    }
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()

    // Save device token to server
    let body: [String: Any] = ["token": "\(token)"]
    var APIbody: Data?
    do {
      APIbody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch let error as NSError {
      print("Failed to convert json to data type: \(error.localizedDescription)")
      return
    }

    callAlfredService(from: "health/apn", httpMethod: "PUT", body: APIbody) { result in
      switch result {
      case .success(let data):
        if let responseJSONData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
          print("Response JSON data = \(responseJSONData)")
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }

  static var orientationLock = UIInterfaceOrientationMask.portrait
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return AppDelegate.orientationLock
  }
}

struct BootUIView: View {
  @EnvironmentObject var stateSettings: StateSettings

  var body: some View {
    VStack {
      if stateSettings.splashScreen {
        SplashUIView()
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
      } else {
        MainUIView()
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.5)))
      }
    }
  }
}

@main
struct AlfredApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var stateSettings = StateSettings()

  var body: some Scene {
    WindowGroup {
      ZStack {
        Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
          .edgesIgnoringSafeArea(.all)
        BootUIView()
          .environmentObject(stateSettings)
      }
    }
  }
}
