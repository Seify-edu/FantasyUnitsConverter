//
//  AppDelegate.swift
//  FantasyUnitsConverter
//
//  Created by andrew mayer on 13.02.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = ConverterViewController()
        window?.makeKeyAndVisible()

        return true
    }

}

