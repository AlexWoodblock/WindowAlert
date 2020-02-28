//
//  AppDelegate.swift
//  WindowAlert
//
//  Created by Alexander on 05/20/2016.
//  Copyright (c) 2016 Alexander. All rights reserved.
//

import UIKit
import WindowAlert

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //let's change default window level for WindowAlert just to demo it
        WindowAlert.defaultWindowLevel = UIWindow.Level.statusBar
        
        return true
    }


}

