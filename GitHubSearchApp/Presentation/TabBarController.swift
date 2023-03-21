//
//  TabBarController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit

class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchRepoViewController = UINavigationController(rootViewController: SearchRepoViewController())
    searchRepoViewController.tabBarItem = UITabBarItem(title: "Repo",
                                                       image: UIImage(systemName: "doc.text"),
                                                       selectedImage: UIImage(systemName: "doc.text.fill"))
    
    let favoriteRepoViewController = FavoriteRepoViewController()
    favoriteRepoViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                         image: UIImage(systemName: "bookmark"),
                                                         selectedImage: UIImage(systemName: "bookmark.fill"))
    
    self.viewControllers = [searchRepoViewController, favoriteRepoViewController]
  }
}
