//
//  AppDelegate.swift
//  testOpensource
//
//  Created by Thanakorn Thanom on 1/6/2565 BE.
//

import UIKit
import AmityUIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AmityUIKitManager.setup(apiKey: "b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f", region: .SG)
 
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        print(url)
        
        let vc = AmityPostTargetPickerViewController.make(postContentType: .post)
          
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return true }
            
            let navController = UINavigationController(rootViewController: vc)
            
            navController.modalPresentationStyle = .fullScreen
            
            window.rootViewController = navController
     return true
    }
    
    



}

