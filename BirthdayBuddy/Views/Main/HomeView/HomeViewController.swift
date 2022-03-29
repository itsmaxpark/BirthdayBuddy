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
                CollectionViewCellViewModel(name: "March", backgroundColor: .blue),
                CollectionViewCellViewModel(name: "April", backgroundColor: .red),
                CollectionViewCellViewModel(name: "May", backgroundColor: .green),
                CollectionViewCellViewModel(name: "June", backgroundColor: .orange),
                CollectionViewCellViewModel(name: "July", backgroundColor: .blue),
                CollectionViewCellViewModel(name: "August", backgroundColor: .red),
                CollectionViewCellViewModel(name: "September", backgroundColor: .green),
                CollectionViewCellViewModel(name: "October", backgroundColor: .orange),
                CollectionViewCellViewModel(name: "November", backgroundColor: .blue),
                CollectionViewCellViewModel(name: "December", backgroundColor: .red),
                CollectionViewCellViewModel(name: "January", backgroundColor: .green),
                CollectionViewCellViewModel(name: "February", backgroundColor: .orange),
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
