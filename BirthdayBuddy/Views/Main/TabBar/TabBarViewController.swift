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
        
        let vc1 = BetterHomeViewController()
        let vc2 = AddBirthdayViewController()
        let vc3 = SettingsViewController()
                        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        vc1.title = "Birthday Buddy"
        nav2.title = "AddBirthdayViewController"
        nav3.title = "SettingsViewController"
        
        vc1.navigationItem.largeTitleDisplayMode = .automatic
        vc1.navigationController?.navigationBar.tintColor = .systemBackground
        vc1.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        tabBar.isTranslucent = true
        tabBar.tintColor = .clear
        
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill", withConfiguration: config), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Add Birthday", image: UIImage(systemName: "plus.app.fill", withConfiguration: config), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill", withConfiguration: config), tag: 1)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
//        tabBar.standardAppearance = appearance
//        tabBar.scrollEdgeAppearance = appearance
//        tabBar.unselectedItemTintColor = .white
        
        setViewControllers([nav1,nav2,nav3], animated: false)
        
        self.setupTabBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWelcomeVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

