//
//  AppDelegate.swift
//  FoodPin
//
//  Created by Simon Ng on 8/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //當應用程式載入時會被呼叫
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //調整返回按鈕的圖片
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        

        return true
    }


}

