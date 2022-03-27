//
//  AppDelegate.swift
//  Mahallawy
//
//  Created by youssef on 3/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import IQKeyboardManagerSwift
//import TwitterCore
//import TwitterKit
import UserNotifications
import FirebaseMessaging
import MOLH
import AuthenticationServices
import GoogleMobileAds
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var Coordinator : AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        Coordinator = AppCoordinator(Window: window!)
        
         IQKeyboardManager.shared.enable = true
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? Int{
            print(userId)
            Coordinator.isLogIn = true
            Coordinator.firstTimeOpen = false
        }
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: Font.Regular.name, size: 20)!]
         UINavigationBar.appearance().isTranslucent = false
    

      
//        TWTRTwitter.sharedInstance().start(withConsumerKey:"vm4dasvZYI2nDorQC9ziNOEXv", consumerSecret:"8QJVWWl4HuWK1MDfdvUjC6M5JuaXxv6FqPLqRfe3y9O2FoZOsE")

        attempeRegisterForNotification(applection: application)
        MOLH.shared.activate(true)
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            
        }else{
            MOLH.setLanguageTo("ar")
        }
    
        Coordinator.start()
        return true
    }
    // MARK:- use this deleget func to show notification when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge])
    }

    
    // MARK:- use this deleget func to return RegisterForRemoteNotificationsWithDeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    
    // MARK:- use this deleget func to return RegistrationToken fcmToken of fireBase
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
         // MARK :- updateFCMToken For Remote Notifications
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String,
            let fcmToken = fcmToken {
            
            let paremeters : [String : String] = [
                "userid" : userId,
                "token": fcmToken
            ]
            print(fcmToken)
            let ViewModel = HomeViewModel()
            ViewModel.updateFCMToken(parameters: paremeters)
            
        }
    }

    
 
    
    private func attempeRegisterForNotification(applection : UIApplication){
        // MARK:- set Deleget of UserNotificationCenter and Messaging firebase
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        // MARK :- set Authorization Options
        let option : UNAuthorizationOptions = [.alert , .badge , .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: option) { (grented, error) in
            if let  error = error {
                print(error.localizedDescription)
                return
            }
            if grented {
                print("grented.....")
            }else {
                 print("Authorization denied.....")
            }
        }
        
       // MARK :- register For Remote Notifications
        applection.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
//        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
        
        guard
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String,
            let title = alert["title"] as? String,
            let img = userInfo[AnyHashable("image")] as? String,
            let type = userInfo[AnyHashable("type")] as? String,
            let urlphone = userInfo[AnyHashable("urlphone")] as? String
            else {
                // handle any error here
                return
            }
        if title == "تم طلب اودر جديد عليك الاطلاع عليه"{
            UNMutableNotificationContent().sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "delivery_ring.wav"))
        }else if title == "تم طلبك لتوصيل اوردر بادر بالرد سريعا." {
            UNMutableNotificationContent().sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "delivery_ring.wav"))
        }else{
            UNMutableNotificationContent().sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "delivery_ring.wav"))
        }
        
       
        print(title , body , urlphone , img , type)
    }
    


}
extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

    
}
