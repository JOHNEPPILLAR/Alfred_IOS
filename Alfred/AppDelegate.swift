//
//  AppDelegate.swift
//  Alfred
//
//  Created by John Pillar on 20/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()

        // Save device token to server
        let (urlRequest, errorURL) = putAlfredData(
            for: "health/apn"
        )
        if errorURL == nil {
            let jsonDictionary: [String: String] = [
                "token": "\(token)"
            ]
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
                URLSession.shared.uploadTask(with: urlRequest!, from: data) { (responseData, response, error) in
                    if let error = error {
                        print("Error making PUT request: \(error.localizedDescription)")
                        return
                    }

                    if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                        guard responseCode == 200 else {
                            print("Invalid response code: \(responseCode)")
                            return
                        }

                        if let responseJSONData = try? JSONSerialization.jsonObject(with:
                            responseData, options: .allowFragments) {
                            print("Response JSON data = \(responseJSONData)")
                        }
                    }
                }.resume()
            } catch {
                print("Error in converting json data")
            }
        }
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
}
