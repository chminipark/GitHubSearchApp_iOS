//
//  SceneDelegate.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = TabBarController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
