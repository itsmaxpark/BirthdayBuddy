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
//        let layout = createCarouselSection()
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
//    func createCarouselSection() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
//        
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
//        
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        
//        layoutSection.orthogonalScrollingBehavior = .groupPaging
//        
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
//        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
//        layout.configuration = config
//        
//        return layout
//    }
}
