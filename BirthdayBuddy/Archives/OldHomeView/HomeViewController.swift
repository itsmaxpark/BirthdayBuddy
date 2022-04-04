//
//  HomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var selectedCell = UITableViewCell()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday Buddy"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = .black
        return label
    }()

    public let tableView: UITableView = {
        let table = UITableView()
        table.register(
            CarouselViewCell.self,
            forCellReuseIdentifier: CarouselViewCell.identifier
        )
        table.layer.cornerRadius = 10
        table.backgroundColor = UIColor(named: "Light Blue")
        return table
    }()
    
    private let viewModels: [CarouselViewCellViewModel] = [
        CarouselViewCellViewModel(
            viewModels: [
                CollectionViewCellViewModel(name: "January", id: 1),
                CollectionViewCellViewModel(name: "February", id: 2),
                CollectionViewCellViewModel(name: "March", id: 3),
                CollectionViewCellViewModel(name: "April", id: 4),
                CollectionViewCellViewModel(name: "May", id: 5),
                CollectionViewCellViewModel(name: "June", id: 6),
                CollectionViewCellViewModel(name: "July", id: 7),
                CollectionViewCellViewModel(name: "August", id: 8),
                CollectionViewCellViewModel(name: "September", id: 9),
                CollectionViewCellViewModel(name: "October", id: 10),
                CollectionViewCellViewModel(name: "November", id: 11),
                CollectionViewCellViewModel(name: "December", id: 12),
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.overrideUserInterfaceStyle = .light
        tableView.separatorColor = .systemBackground
        view.backgroundColor = .white

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.frame = CGRect(
            x: view.center.x-(titleLabel.intrinsicContentSize.width/2),
            y: view.top+50,
            width: 400,
            height: 50
        )
        tableView.frame = CGRect(
            x: 10,
            y: titleLabel.bottom,
            width: view.width-20,
            height: 730
        )
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModels.count
        } else {
            return 5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CarouselViewCell.identifier,
            for: indexPath
        ) as? CarouselViewCell else {
            fatalError()
        }
//        let layout = createCarouselSection()
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = tableView.cellForRow(at: indexPath)!
    }
}
