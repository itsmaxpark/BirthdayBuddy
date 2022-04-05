//
//  AddBirthdayBottomSheetViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/4/22.
//

import UIKit

class AddBirthdayBottomSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let cellViewModel: [AddBirthdayBottomSheetTableViewCellViewModel] = [
        AddBirthdayBottomSheetTableViewCellViewModel(
            text: "Add Birthday",
            fontSize: 20,
            textColor: UIColor.label,
            image: UIImage(systemName: "plus")
        )
    ]
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(AddBirthdayBottomSheetTableViewCell.self, forCellReuseIdentifier: AddBirthdayBottomSheetTableViewCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        headerView.addSubview(headerTextLabel)
        headerView.addSubview(closeButton)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        
        tableView.frame = CGRect(
            x: 0,
            y: headerView.bottom,
            width: view.width,
            height: view.height-headerView.height
        )
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
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
        let vc = BetterAddBirthdayViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true)
    }
}
