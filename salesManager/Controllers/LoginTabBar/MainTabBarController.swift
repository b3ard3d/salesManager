//
//  MainTabBarController.swift
//  salesManager
//
//  Created by Роман Кокорев on 18.12.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let defaults = UserDefaults.standard
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
        
    func setupTabBar() {
        
        let logInViewController = createNavController(viewController: LogInViewContoller(), itemName: "Авторизация", ItemImage: "person.crop.circle")
        let settingsViewController = createNavController(viewController: SettingsViewController(), itemName: "Настройки", ItemImage: "gear")
        viewControllers = [logInViewController, settingsViewController]
        
   /*     let userAuthorization = defaults.bool(forKey: "userAuthorization")
              if userAuthorization == true {
                  viewControllers?.removeAll()
                  
                  let partnersViewController = createNavController(viewController: PartnersViewController(), itemName: "Партнеры", ItemImage: "person.crop.circle")
                  let coldClientsViewController = createNavController(viewController: ColdClientsViewController(), itemName: "Холодные клиенты", ItemImage: "gear")
                  viewControllers = [partnersViewController, coldClientsViewController]
              } */
    }
        
    func createNavController(viewController: UIViewController, itemName: String, ItemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: ItemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0))  ,tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = item
        return navigationController
    }
}

