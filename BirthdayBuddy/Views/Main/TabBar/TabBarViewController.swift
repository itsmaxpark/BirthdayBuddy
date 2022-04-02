//
//  TabBarViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let backgroundView = TabBarBackgroundView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabBarController"
        
        let vc1 = HomeViewController()
        let vc2 = AddBirthdayViewController()
        let vc3 = SettingsViewController()
                        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.title = "HomeViewController"
        nav2.title = "AddBirthdayViewController"
        nav3.title = "SettingsViewController"
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill", withConfiguration: config), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Add Birthday", image: UIImage(systemName: "plus.app.fill", withConfiguration: config), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill", withConfiguration: config), tag: 1)
        
        nav1.additionalSafeAreaInsets.top = CGFloat(20)
        nav2.additionalSafeAreaInsets.top = CGFloat(20)
        nav3.additionalSafeAreaInsets.top = CGFloat(20)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        nav1.navigationBar.standardAppearance = appearance
        nav2.navigationBar.standardAppearance = appearance
        nav3.navigationBar.standardAppearance = appearance
        
        setViewControllers([nav1,nav2,nav3], animated: false)
        
        self.setupTabBar()
        
        view.addSubview(backgroundView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
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
    
    func setupTabBar() {
        tabBar.backgroundColor = UIColor(named: "Light Blue")
        tabBar.layer.masksToBounds = true
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .white
    }
}

