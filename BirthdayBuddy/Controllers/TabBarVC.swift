//
//  TabBarViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class TabBarVC: UITabBarController {
    
    private var homeVC = HomeVC()
    private var addBirthdayBottomSheetVC = BottomSheetVC()
    private var settingsVC = SettingsVC()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarVC()
        configureNavVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWelcomeVC()
    }
    
    private func configureTabBarVC() {
        title = "TabBarController"
        delegate = self
    }
    
    private func configureNavVC() {
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        let betterHomeNavVC = UINavigationController(rootViewController: homeVC)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        
        homeVC.title = "Birthday Buddy"
        betterHomeNavVC.navigationBar.prefersLargeTitles = false
        betterHomeNavVC.navigationItem.largeTitleDisplayMode = .never
        betterHomeNavVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        betterHomeNavVC.tabBarItem.image = UIImage(systemName: "house.fill")!.withBaselineOffset(fromBottom: 6)
        
        settingsVC.title = "Settings"
        settingsVC.delegate = self
        settingsNavVC.title = "SettingsViewController"
        settingsNavVC.navigationBar.prefersLargeTitles = true
        settingsNavVC.navigationItem.largeTitleDisplayMode = .always
        settingsNavVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        betterHomeNavVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 0
        )
        
        addBirthdayBottomSheetVC.tabBarItem = UITabBarItem(
            title: "Add Birthday",
            image: UIImage(systemName: "plus.app.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 1
        )
        
        settingsNavVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape.fill", withConfiguration: config)!.withBaselineOffset(fromBottom: 6),
            tag: 2
        )
        
        setViewControllers([betterHomeNavVC,addBirthdayBottomSheetVC,settingsNavVC], animated: false)
    }
    
    public func presentWelcomeVC() {
        if !WelcomeVC.isLoggedIn {
            let vc = WelcomeVC()
            let nav = UINavigationController(rootViewController: vc)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(nav)
        }
    }
    
    public func presentAddBirthdayVC() {
        let vc = AddBirthdayVC()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}

// MARK: - Tab Bar Delegate
extension TabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is BottomSheetVC {
            let vc = BottomSheetVC()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(vc, animated: true)
            return false
        }
        return true
    }
}

// MARK: - Add Birthday VC Delegate
extension TabBarVC: AddBirthdayViewControllerDelegate {
    
    func refreshCollectionView() {
        guard let nav = viewControllers?[0] as? UINavigationController else { return }
        guard let vc = nav.viewControllers.first as? HomeVC else { return }
        vc.collectionView.reloadData()
    }
}

// MARK: - Settings VC Delegate
extension TabBarVC: SettingsViewControllerDelegate {
    
    func getNumberOfBirthdays() -> String {
        homeVC.getNumberOfBirthdays()
    }
}


