//
//  AppDelegate.swift
//  gameOfchats
//
//  Created by Kev1 on 4/2/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
import Firebase // firebase integration 1
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //FIRApp.configure() // firebase integration 2
        // Override point for customization after application launch.
        // replacing the storyboard with my own window here.
        window = UIWindow(frame: UIScreen.main.bounds)
        // make the window visible
        window?.makeKeyAndVisible()
        // create the stoyboard manually here. It needs a RootViewController we will use a nav controller
        
       let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .horizontal
        
        window?.rootViewController = UINavigationController(rootViewController: MessagesController())
        
////        window?.rootViewController = UINavigationController(rootViewController: MessagesController2())
        //
        //REMOTE NOTIFICATION
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
        
//        UINavigationBar.appearance().tintColor = UIColor(r: 230, g: 32, b: 31)
       application.statusBarStyle = .lightContent //This and infoplist makes status white
        
//        UINavigationBar.appearance().barTintColor = UIColor(r: 61, g: 91, b: 151)
//        
//        // Make the nav bar look deeper
//        let statusBarbackgroundView = UIView()
//        statusBarbackgroundView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        window?.addSubview(statusBarbackgroundView)
        
               
        
        
        UINavigationBar.appearance().barTintColor = aquaBlueChatfixColor
        
        // Make the nav bar look deeper
        let statusBarbackgroundView = UIView()
        statusBarbackgroundView.backgroundColor = aquaBlueChatfixColor
        window?.addSubview(statusBarbackgroundView)
        
        
        
        //Constraints
        window?.addContraintsWithFormat(format: "H:|[v0]|", views: statusBarbackgroundView)
        window?.addContraintsWithFormat(format: "V:|[v0(20)]", views: statusBarbackgroundView)
        
        //
//        UINavigationBar.appearance().shadowImage = UIImage()
//                UINavigationBar.appearance().setBackgroundImage(UIImage().forBarMetrics: .default)
//        UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .default)

        
        
        return true
    }
    
    //
    
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        
        if ( application.applicationState == UIApplicationState.active)
        {
            print("Active")
            // App is foreground and notification is recieved,
            // Show a alert.
        }
        else if( application.applicationState == UIApplicationState.background)
        {
            print("Background")
            // App is in background and notification is received,
            // You can fetch required data here don't do anything with UI.
        }
        else if( application.applicationState == UIApplicationState.inactive)
        {
            print("Inactive")
            // App came in foreground by used clicking on notification,
            // Use userinfo for redirecting to specific view controller.
        }
    }
    
    
    
    
    
    
    // [START receive_message]
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        print("KM userInfo is:", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        // Note that this callback will be fired everytime a new token is generated, including the first
        // time. So if you need to retrieve the token as soon as it is available this is where that
        // should be done
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm(){
        // Won't connect since there is no token
        
        guard  FIRInstanceID.instanceID().token() != nil  else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM")
            }
        }
        
    }
    // [END connect_to_fcm]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)");
    }
    
    //
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        //
        // With swizzling disabled you must set the APNs token here.
        // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // [[FIRMessaging messaging] disconnect];
        // NSLog(@"Disconnected from FCM");
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM")
        
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //TODO
    func fireNotification(alert: String) {
        
        //let trigger = UNNotificati
        
        
        /*
         let content = UNMutableNotificationContent()
         content.title = "Tutorial Reminder"
         content.body = "Just a reminder to read your tutorial over at appcoda.com!"
         content.sound = UNNotificationSound.default()
         
         //  let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
         UNUserNotificationCenter.current().add(request) {(error) in
         if let error = error {
         print("Uh oh! We had an error: \(error)")
         }
         }
         */
        
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
         //   print("Message ID: \(messageID)")
            //This method is called when the rootViewController is set and the view.
            // And the View controller is ready to get touches or events.
            let alert = UIAlertController(title: "Alert", message: messageID as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]


// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]
