//
//  TabBarViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabBarController"
        
        let vc1 = BetterHomeViewController()
        let vc2 = AddBirthdayBottomSheetViewController()
        let vc3 = SettingsViewController()
                        
        let nav1 = UINavigationController(rootViewController: vc1)
//        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        vc1.title = "Birthday Buddy"
        vc2.title = "AddBirthdayViewController"
        nav3.title = "SettingsViewController"
        
//        vc1.tabBarItem.tag = 0
        vc2.tabBarItem.tag = 1
//        vc3.tabBarItem.tag = 2
        
//        vc1.navigationItem.largeTitleDisplayMode = .automatic
//        vc1.navigationController?.navigationBar.tintColor = .systemBackground
        vc1.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill", withConfiguration: config), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Add Birthday", image: UIImage(systemName: "plus.app.fill", withConfiguration: config), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill", withConfiguration: config), tag: 1)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        setViewControllers([nav1,vc2,nav3], animated: false)
        
        self.delegate = self
        
        self.setupTabBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWelcomeVC()
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // if add birthday tab is selected, present a modal vc
        if viewController is AddBirthdayBottomSheetViewController {
            let vc = AddBirthdayBottomSheetViewController()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(vc, animated: true)
            return false
        }
        return true
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
        tabBar.tintColor = .systemBlue  // changes selected item color
        tabBar.unselectedItemTintColor = .white  // changes non selected item color
        tabBar.isTranslucent = true
    }
}
