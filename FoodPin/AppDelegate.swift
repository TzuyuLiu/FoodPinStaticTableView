//
//  AppDelegate.swift
//  FoodPin
//
//  Created by Simon Ng on 8/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//


import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //當應用程式載入時會被呼叫
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //調整返回按鈕的圖片
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        //標籤列
        //更改目前選到的標籤顏色
        UITabBar.appearance().tintColor = UIColor(red: 231, green: 76, blue: 60)
        //更改標籤列背景顏色
        UITabBar.appearance().barTintColor = UIColor(red: 250, green: 250, blue: 250)
        //可以定義標籤列的背景圖片
        //UITabBar.appearance().backgroundImage = UIImage(named: "tabbar-background")
        return true
    }
    
    
    // MARK: - Core Data stack
    
    //persistentContainer是NSPersistentContainer的實例
    lazy var persistentContainer: NSPersistentContainer = {
        
        //以名為FoodPin的持久性儲存器來初始化，在應用程式中封裝Core Data堆疊
        let container = NSPersistentContainer(name: "FoodPin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    //當需要在持久性儲存器插入/更新/刪除資料時，就呼叫此方法
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



