//
//  TabBarViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var vc1 = BetterHomeViewController()
    private var vc2 = AddBirthdayBottomSheetViewController()
    private var vc3 = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabBarController"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        vc1.title = "Birthday Buddy"
        vc3.title = "Settings"
        nav3.title = "SettingsViewController"
        
        nav1.navigationBar.prefersLargeTitles = false
        nav1.navigationItem.largeTitleDisplayMode = .never
        nav1.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
//        nav2.navigationBar.prefersLargeTitles = false
//        nav2.navigationItem.largeTitleDisplayMode = .never
//        nav2.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        nav3.navigationBar.prefersLargeTitles = true
        nav3.navigationItem.largeTitleDisplayMode = .always
        nav3.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 0
        )
        vc2.tabBarItem = UITabBarItem(
            title: "Add Birthday",
            image: UIImage(systemName: "plus.app.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 1
        )
        nav3.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 2
        )
        
        nav1.tabBarItem.image = UIImage(systemName: "house.fill")!.withBaselineOffset(fromBottom: 6)
        
        setViewControllers([nav1,vc2,nav3], animated: false)
        
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWelcomeVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            let vc = WelcomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(nav)
        }
    }
    
    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "Light Blue")
        appearance.shadowColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.label
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        tabBar.standardAppearance = appearance
    }
    func presentAddBirthdayVC() {
        let vc = BetterAddBirthdayViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}

extension TabBarViewController: AddBirthdayViewControllerDelegate {
    func refreshCollectionView() {
        guard let nav = viewControllers?[0] as? UINavigationController else {
            return
        }
        guard let vc = nav.viewControllers.first as? BetterHomeViewController else {
            return
        }
        vc.fetchPerson { newPersons in
            DispatchQueue.main.async {
                vc.collectionView.reloadData()
            }
        }
    }
}


