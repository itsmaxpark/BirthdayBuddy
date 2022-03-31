//
//  HomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            CarouselViewCell.self,
            forCellReuseIdentifier: CarouselViewCell.identifier
        )
        return table
    }()
    
    private let viewModels: [CarouselViewCellViewModel] = [
        CarouselViewCellViewModel(
            viewModels: [
                CollectionViewCellViewModel(name: "March", backgroundColor: .blue, id: 3),
                CollectionViewCellViewModel(name: "April", backgroundColor: .green, id: 4),
                CollectionViewCellViewModel(name: "May", backgroundColor: .yellow, id: 5),
                CollectionViewCellViewModel(name: "June", backgroundColor: .orange, id: 6),
                CollectionViewCellViewModel(name: "July", backgroundColor: .purple, id: 7),
                CollectionViewCellViewModel(name: "August", backgroundColor: .pink, id: 8),
                CollectionViewCellViewModel(name: "September", backgroundColor: .blue, id: 9),
                CollectionViewCellViewModel(name: "October", backgroundColor: .green, id: 10),
                CollectionViewCellViewModel(name: "November", backgroundColor: .yellow, id: 11),
                CollectionViewCellViewModel(name: "December", backgroundColor: .orange, id: 12),
                CollectionViewCellViewModel(name: "January", backgroundColor: .purple, id: 1),
                CollectionViewCellViewModel(name: "February", backgroundColor: .pink, id: 2),
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.overrideUserInterfaceStyle = .light
        tableView.separatorColor = .systemBackground
        view.backgroundColor = .white

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CarouselViewCell.identifier,
            for: indexPath
        ) as? CarouselViewCell else {
            fatalError()
        }
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
