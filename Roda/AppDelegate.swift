//
//  AppDelegate.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseAuth
import UserNotifications
import SWRevealViewController
import IQKeyboardManagerSwift
import SystemConfiguration
import FirebaseMessaging
import AWSS3
import AWSCore
import AWSCognito
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        AppLocationManager.shared.locationManager.requestAlwaysAuthorization()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, _) in
            print("granted:\(granted)")
        }
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        GMSServices.provideAPIKey(APIHelper.shared.gmsServiceKey)
        GMSPlacesClient.provideAPIKey(APIHelper.shared.gmsPlacesKey)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .txtColor
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
        
        initializeS3()
        
        application.isIdleTimerDisabled  = true
        
        APIHelper.shared.delegate = self
                
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        APIHelper.shared.fetchUsers()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let launch = UINavigationController(rootViewController: LaunchVC())
        launch.interactivePopGestureRecognizer?.isEnabled = false
        launch.navigationBar.isHidden = true
        self.window?.rootViewController = launch
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        APIHelper.shared.saveContext()
    }
    
    func initializeS3() {
        let poolId = "us-east-2:d39598d4-bbec-4b7a-864c-21cad8c4a468"
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2, identityPoolId:poolId)
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().apnsToken = deviceToken
        print("APNs device token: \(deviceToken)")

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        APIHelper.shared.deviceToken = fcmToken ?? ""
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
       
        print("recieved push resp: ",userInfo)
        self.performActions(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notification resp:",userInfo)
        self.performActions(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push resp", notification.request.content.userInfo)
        
        if UIApplication.shared.applicationState != .active {
            completionHandler([.alert,.sound,.badge])
        } else {
            completionHandler([.alert,.badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    func performActions(_ info: [AnyHashable:Any]) {

        func performActionForMsg(_ msg: String, details: [String: AnyObject]) {
            switch msg {
            case "trip_accepted", "driver_arrived", "driver_started_the_trip", "driver_end_the_trip":
                NotificationCenter.default.post(name: .tripStateChanged, object: nil, userInfo: details)
            case "trip_location_changed":
                NotificationCenter.default.post(name: .locationChanged, object: nil, userInfo: details)
            case "local_to_rental":
                NotificationCenter.default.post(name: .localToRental, object: nil, userInfo: details)
            case "driver_rejected":
                NotificationCenter.default.post(name: .driverRejected, object: nil, userInfo: details)
            case "Another user loggedin":
                NotificationCenter.default.post(name: .anotherUserLogin, object: nil, userInfo: details)
            case "Trip cancelled":
                NotificationCenter.default.post(name: .tripCancelled, object: nil, userInfo: details)
            case "no_driver_found":
                NotificationCenter.default.post(name: .noDriverFound, object: nil, userInfo: details)
            case "Driver_started":
                NotificationCenter.default.post(name: .driverStarted, object: nil, userInfo: details)
            case "requested_another_driver":
                NotificationCenter.default.post(name: .requestAnotherDriver, object: nil, userInfo: details)
            case "ride_later_cancelled_because_of_no_driver_found":
                NotificationCenter.default.post(name: .rideLaterNoCaptainFound, object: nil, userInfo: details)
            default:
                break
            }
        }
        
        if let body = info["body"] as? [String: AnyObject] {
            
            if let notificationEnum = body["notification_enum"] as? String {
                print("action performed")
                performActionForMsg(notificationEnum, details: body)
            }
        } else if let str = info["body"] as? String, let data = str.data(using: .utf8),
                  let bodyDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            
            if let notificationEnum = bodyDict["notification_enum"] as? String {
                print("action performed")
                performActionForMsg(notificationEnum, details: bodyDict)
            }
        }
            
    }

}


extension AppDelegate: LogoutDelegate {
    func logout() {
        MySocketManager.shared.socket.disconnect()
        checkLogin()
    }
    
    func checkLogin() {
      
        self.window = UIWindow(frame: UIScreen.main.bounds)
      
        let firstvc = Initialvc()
        let mainViewController = UINavigationController(rootViewController: firstvc)
        
        mainViewController.interactivePopGestureRecognizer?.isEnabled = false
        mainViewController.navigationBar.isHidden = true
        if APIHelper.shared.userDetails != nil {
            
            let revealVC = SWRevealViewController()
            revealVC.panGestureRecognizer().isEnabled = false
            
            let menuVC = MenuViewController()
                        
            let pickupVC = TaxiPickupVC()
            revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                revealVC.rearViewController = menuVC
                revealVC.rightViewController = nil
            } else {
                revealVC.rearViewController = nil
                revealVC.rightViewController = menuVC
            }
            pickupVC.navigationController?.navigationBar.isHidden = true
            mainViewController.setViewControllers([firstvc, revealVC], animated: false)
        }
        self.window?.rootViewController = mainViewController
        self.window?.makeKeyAndVisible()
        
    }
}
