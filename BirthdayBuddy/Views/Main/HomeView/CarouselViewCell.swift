//
//  CarouselViewCellTableViewCell.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/29/22.
//

import UIKit

class CarouselViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "CarouselViewCell"
    
    private var viewModels: [CollectionViewCellViewModel] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 22, bottom: 2, right: 2)
        layout.minimumLineSpacing = 22
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as? CollectionViewCell else {
            fatalError()
        }
        // if cell is dequeued, it retains the custom uiview
        // we need to reset the uiview if it is dequeued
        let model = viewModels[indexPath.row]
        for sublayer in cell.layer.sublayers! {
            if let _ = sublayer as? CAGradientLayer { // Check only gradient layers
                if sublayer.name != model.name { // need to update gradient since cell is reused
                    sublayer.removeFromSuperlayer()
                    cell.configure(with: model)
                    cell.setGradientBackground(id: model.id)
                }
            } else { // cell is not dequeued
                cell.configure(with: model)
                cell.setGradientBackground(id: model.id)
            }
        }
        return cell
    }
    
    func configure(with viewModel: CarouselViewCellViewModel) {
        self.viewModels = viewModel.viewModels
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 220
        let height: CGFloat = 300
        return CGSize(width: width, height: height)
    }
}
