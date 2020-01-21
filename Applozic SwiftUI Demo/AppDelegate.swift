//
//  AppDelegate.swift
//  Applozic SwiftUI Demo
//
//  Created by Mukesh on 20/01/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import UIKit
import Applozic
import ApplozicSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    static let config: ALKConfiguration = {
        var config = ALKConfiguration()
        // Change config based on requirement like:
        // config.isTapOnNavigationBarEnabled = false

        return config
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ALKPushNotificationHandler.shared.dataConnectionNotificationHandlerWith(AppDelegate.config)
        let alApplocalNotificationHnadler : ALAppLocalNotifications =  ALAppLocalNotifications.appLocalNotificationHandler()
        alApplocalNotificationHnadler.dataConnectionNotificationHandler()

        UNUserNotificationCenter.current().delegate = self
        registerForNotification()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("APP IN BACKGROUND")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "APP_ENTER_IN_BACKGROUND"), object: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        ALPushNotificationService.applicationEntersForeground()
        print("APP IN FOREGROUND")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "APP_ENTER_IN_FOREGROUND"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ALDBHandler.sharedInstance().saveContext()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print("DEVICE TOKEN DATA :: \(deviceToken.description)")
        var deviceTokenString: String = ""
        for i in 0..<deviceToken.count
        {
            deviceTokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("DEVICE TOKEN STRING :: \(deviceTokenString)")

        if (ALUserDefaultsHandler.getApnDeviceToken() != deviceTokenString)
        {
            let alRegisterUserClientService: ALRegisterUserClientService = ALRegisterUserClientService()
            alRegisterUserClientService.updateApnDeviceToken(withCompletion: deviceTokenString, withCompletion: { (response, error) in
                print ("REGISTRATION RESPONSE :: \(String(describing: response))")
            })
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Couldn’t register: \(error)")
    }

    func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let service = ALPushNotificationService()
        guard !service.isApplozicNotification(notification.request.content.userInfo) else {
            service.notificationArrived(to: UIApplication.shared, with: notification.request.content.userInfo)
            completionHandler([])
            return
        }
        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let service = ALPushNotificationService()
        let dict = response.notification.request.content.userInfo
        guard !service.isApplozicNotification(dict) else {
            switch UIApplication.shared.applicationState {
            case .active:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_ACTIVE.rawValue))
            case .background:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_BACKGROUND.rawValue))
            case .inactive:
                service.processPushNotification(dict, updateUI: NSNumber(value: APP_STATE_INACTIVE.rawValue))
            @unknown default:
                print("Not handling this application state")
            }
            completionHandler()
            return
        }
        completionHandler()
    }
}

