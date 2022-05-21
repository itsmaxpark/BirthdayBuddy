//
//  SettingsViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import FirebaseAuth

protocol SettingsViewControllerDelegate: AnyObject {
    func getNumberOfBirthdays() -> String
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    private let viewModels: [SettingsTableViewCellViewModel] = [
        SettingsTableViewCellViewModel(text: "Statistics", color: .white),
//        SettingsTableViewCellViewModel(text: "Remove Delivered Notifications"),
        SettingsTableViewCellViewModel(text: "Delete All Birthdays", color: .white),
        SettingsTableViewCellViewModel(text: "Sign Out", color: .systemRed),
    ]
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.alwaysBounceVertical = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell else {
            fatalError()
        }
        cell.configure(viewModel: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        if index == 0 {
            let message = delegate?.getNumberOfBirthdays()
            let alert = UIAlertController(title: "Statistics", message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        } else if index == 1 {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete all birthdays on your account?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirmButton = UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
                CoreDataManager.shared.deleteAllBirthdays()
            })
            alert.addAction(confirmButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
//        } else if index == 2 {
//            let message = NotificationManager.shared.getNumberOfDeliveredNotifications()
//            let alert = UIAlertController(title: "Remove Pending Notifications", message: message, preferredStyle: .alert)
//            let confirmButton = UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
//                NotificationManager.shared.removeAllPendingNotifications()
//            })
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(confirmButton)
//            alert.addAction(cancelButton)
//            self.present(alert, animated: true)
        } else if index == 2 {
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let signOutButton = UIAlertAction(title: "Sign Out", style: .default, handler: { _ in
                SignOutHelper.signOut()
            })
            alert.addAction(signOutButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
        }
    }
}
