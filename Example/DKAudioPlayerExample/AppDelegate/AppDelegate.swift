//
//  AppDelegate.swift
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 22.11.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAppearance()

        tabBarController = UITabBarController()
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barStyle = .default
        
        let viewController = ViewController(nibName: "ViewController", bundle: nil)
        tabBarController?.addChild(viewController)

        let tableViewController = AudioTableViewController(style: UITableView.Style.plain)
        let navigationController = UINavigationController(rootViewController: tableViewController)
        tabBarController?.addChild(navigationController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

    func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
