      //
//  AppDelegate.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 26/12/17.
//  Copyright © 2017 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import OneSignal
import Firebase
      
var isFirstTimeFromAppDelegate = true
@UIApplicationMain
     
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locManager = CLLocationManager()
    var reorder = APIManager.sharedInstance.reorderLocation()
    var secretKey = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        isFirstTimeFromAppDelegate = false
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "756e7da6-3830-42b7-8339-217144bba8ec",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        UIApplication.shared.statusBarStyle = .lightContent
        
        LocationReporter.shared.userLocation.observe { result in
            switch result {
            case let .value(location):
                SavedData.setTheLatitude(double: location.coordinate.latitude)
                SavedData.setTheLongitude(double: location.coordinate.longitude)
                SavedData.setSecretKey(secretKey: "5250ca22994c5391cd0d0be548fe8ef1")
            case let .failure(error):
                print(error)
            }
        }
        
//        locManager.requestWhenInUseAuthorization()
        
        if isFirstTimeFromAppDelegate == false {
            if SavedData.getTheName() != "" {
               
                print("Si hay sesión iniciada")
                self.getTheNews()
                self.getTheClubes()
                self.getTheClubesTwo()
                
            } else {
                isFirstTimeFromAppDelegate = true 
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
             }
        }
        
        /*
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            currentLocation = locManager.location
            SavedData.setTheLatitude(double: currentLocation.coordinate.latitude)
            SavedData.setTheLongitude(double: currentLocation.coordinate.longitude)
            SavedData.setSecretKey(secretKey: "5250ca22994c5391cd0d0be548fe8ef1")
        }
        */
        let screenSiz: CGRect = UIScreen.main.bounds
        print("Este es el tamaño de la pantalla", screenSiz)
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        
        FirebaseApp.configure()
        ChatManager.configure()
        
        return true
    }
    
   
    

    func getTheClubes() {
        APIManager.sharedInstance.getClubesForRegister(onSuccess: { json in
            DispatchQueue.main.async {
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                 let initialViewController : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabBarController") as!  UITabBarController
                 self.window = UIWindow(frame: UIScreen.main.bounds)
                 self.window?.rootViewController = initialViewController
                 self.window?.makeKeyAndVisible()
                
            }
        }, onFailure: { error in
            
        })
        
    }
    
    func getTheClubesTwo() {
        APIManager.sharedInstance.getClubesForRegister(onSuccess: { json in
            DispatchQueue.main.async {
             //   let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             //   let initialViewController : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabBarController") as!  UITabBarController
            //    self.window = UIWindow(frame: UIScreen.main.bounds)
         //       self.window?.rootViewController = initialViewController
             //   self.window?.makeKeyAndVisible()
                
            }
        }, onFailure: { error in
            
        })
        
    }
    func getTheNews(){
        APIManager.sharedInstance.getNews(onSuccess: { json in
            DispatchQueue.main.async {
                if APIManager.sharedInstance.status == true {
                    
                    print("Success Request GetCharges")
                }
            }
            
        }, onFailure: { error in
            
        })
    }
    func applicationWillResignActive(_ application: UIApplication) {

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
