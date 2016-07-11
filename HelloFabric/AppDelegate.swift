//
//  AppDelegate.swift
//  HelloFabric
//
//  Created by toyboy17 on 2016/7/4.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Appsee
import Branch
import DigitsKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self, Appsee.self, Branch.self, Digits.self])

        
        
        // TODO: Move this tor whee you establish a user session
        self.logUser()

        return true
    }
    
    //AppSee實作 Set the application's user identifier step1
    func onUserSessionStarted() {
        Appsee.setUserID("User1234")
    }
    //AppSee實作 Add application events
    func onUserDeposit() {
    Appsee.addEvent("UserDepositFinished")
    Appsee.addEvent("ItemPurchased", withProperties: ["Price"  : 100,
    "Country": "USA"])
    }

    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        // app使用者資訊
        Crashlytics.sharedInstance().setUserEmail("xxx@gmail.com")
        Crashlytics.sharedInstance().setUserIdentifier("xxxxx")
        Crashlytics.sharedInstance().setUserName("guest")
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

