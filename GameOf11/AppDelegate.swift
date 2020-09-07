//
//  AppDelegate.swift
//  GameOf11
//
//  Created by Tanvir Palash on 30/11/18.
//  Copyright © 2018 Tanvir Palash. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

import Firebase
import FirebaseMessaging
import UserNotifications
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        print("didFinishLaunchingWithOptions.........")
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let tabVC = story.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
//
//        
//        let names = ["HOME".localized, "MY CONTEST".localized, "PROFILE".localized,"MORE".localized]
//        var index = 0
//        if let views = tabVC.viewControllers {
//            for tab in views {
//                tab.tabBarItem.title = names[index]
//                index = index + 1
//            }
//        }
//        self.window?.rootViewController = tabVC

        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        UserDefaults.standard.set(version, forKey: "currentVersionNumber")
        
        print("versionNumber...........",version)
        
        
        APIManager.manager.getAppInfo{ (infoDic) in
            
            let mediaUrl = infoDic["media_base_url"] as! String
            
            print("mediaUrl...........?????????",mediaUrl)
            
            UserDefaults.standard.set( mediaUrl, forKey: "media_base_url")
            
            let shouldUpdate = infoDic["should_update"] as! Int
            
            UserDefaults.standard.set( shouldUpdate, forKey: "shouldUpdate")
            
            
            let storeVersion = infoDic["store_version"] as! String
           // let storeVersion = "1.1.2"
            
            
            UserDefaults.standard.set(storeVersion, forKey: "storeVersionNumber")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "versionCheck"), object: nil, userInfo: nil)
            
        }
     
    
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
           
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(false, forKey: "DarkMode")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let tutorialVC = story.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            
            self.window?.rootViewController = tutorialVC
        }

        IQKeyboardManager.shared.enable = true

        
        UserDefaults.standard.set("upcoming", forKey: "selectedMyContest")
        UserDefaults.standard.set("cricket", forKey: "selectedGameType")
        
        print("appdelegate..............match",UserDefaults.standard.string(forKey: "selectedgametype"))
        
        
        // One Signal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "64741dfa-452e-4a46-a1d0-c79a2f64e298",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
  
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let refreshedToken = Messaging.messaging().fcmToken {
            print("InstanceID token: \(refreshedToken)")
        }
        Messaging.messaging().apnsToken = deviceToken
        
        // Need to call api to send token to server whenever api is ready
        //subscribe to channel provided by Anik
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    //Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
        print("///////////",notification.request.content.userInfo)
    }
    //Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("///////////.................",response.notification.request.content.userInfo)
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

