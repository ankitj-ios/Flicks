//
//  AppDelegate.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let moviesNavigationControllerIdentifier = "MoviesNavigationController"
        
        let nowPlayingNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier(moviesNavigationControllerIdentifier) as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! FlicksHomeViewController
        nowPlayingViewController.endPointSuffix = "now_playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "playing-1")
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        /* if we need to set any new notification on a particular tab bar item*/
        // nowPlayingNavigationController.tabBarItem.badgeValue = "1"
        
        let topRatedNavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier(moviesNavigationControllerIdentifier) as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! FlicksHomeViewController
        topRatedViewController.endPointSuffix = "top_rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "star-1")
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
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

