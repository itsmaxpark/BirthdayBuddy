//
//  AddBirthdayBottomSheetViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/4/22.
//

import UIKit

class BottomSheetVC: UIViewController {
    
    private let cellViewModel = BottomSheetCellViewModels.viewModels
    
    private let headerView = BBView(backgroundColor: .systemBackground)
    private let headerTextLabel = BBLabel(text: "Create New", font: .systemFont(ofSize: 15), textColor: .systemGray)
    private let closeButton = BBButton(image: Image.xMark, contentMode: .scaleAspectFill)
    private let tableView = UITableView()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddBirthdayBottomSheetTableViewCell.self, forCellReuseIdentifier: AddBirthdayBottomSheetTableViewCell.identifier)
        
        tableView.frame = CGRect(
            x: 0,
            y: headerView.bottom,
            width: view.width,
            height: view.height-headerView.height
        )
    }
    
    private func configureUI() {
        view.addSubview(headerView)
        headerView.addSubview(headerTextLabel)
        headerView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: 40
        )
        
        headerTextLabel.frame = CGRect(
            x: 20,
            y: headerView.center.y-20,
            width: headerView.width-50,
            height: 40
        )
        
        closeButton.frame = CGRect(
            x: headerTextLabel.right,
            y: 10,
            width: headerView.height/2,
            height: headerView.height/2
        )
    }
    
    // MARK: - Selectors
    @objc func didTapClose() {
        dismiss(animated: true)
    }
}

// MARK: - Table View Delegate and Data Source
extension BottomSheetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AddBirthdayBottomSheetTableViewCell.identifier,
            for: indexPath
        ) as? AddBirthdayBottomSheetTableViewCell else {
            fatalError()
        }
        cell.configure(viewModel: cellViewModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        let tabBarVC = self.presentingViewController as? TabBarVC
        tabBarVC?.presentAddBirthdayVC()
    }
}
