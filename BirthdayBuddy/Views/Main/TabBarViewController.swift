//
//  TabBarViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewController()
        let vc2 = AddBirthdayViewController()
        let vc3 = SettingsViewController()
                        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "AddBirthday", image: UIImage(systemName: "plus.app.fill"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 1)
                
        setViewControllers([nav1,nav2,nav3], animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWelcomeVC()
        
    }
    
    func presentWelcomeVC() {
        if !WelcomeViewController.isLoggedIn {
            print("TabBarViewController: Presenting WelcomeViewController")
            let vc = WelcomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(nav)
        }
    }
}
