//
//  AppDelegate.swift
//  ExpressBusTimetable
//
//  Created by akira on 2/4/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import XCGLogger
import ChameleonFramework

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.default

    #if DEBUG

    log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)

    #else

    log.setup(level: .error, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)

    #endif

    // Alternatively, you can use emoji to highlight log levels (you probably just want to use one of these methods at a time).
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    log.formatters = [emojiLogFormatter]

    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Set Color
        EBTColor.sharedInstance.theme = UserDefaults.colorTheme
        Analytics.setUserProperty(EBTColor.sharedInstance.theme.rawValue, forName: "theme_color")
        let primaryColor = EBTColor.sharedInstance.primaryColor
        let tintColor = EBTColor.sharedInstance.tintColor
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().isTranslucent = false
        let textColor = EBTColor.sharedInstance.primaryTextColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: textColor]
        UINavigationBar.appearance().tintColor = tintColor
        if !EBTColor.sharedInstance.isPrimaryTextColorBlack {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
        UITabBar.appearance().barTintColor = primaryColor
        UITabBar.appearance().tintColor = tintColor
        UITabBar.appearance().isTranslucent = false

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4629563331084064~1123430830")

        return true
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
