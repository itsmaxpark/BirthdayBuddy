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
    
    private let transitioningDelegate = CustomTransitioningDelegate()
    
    var selectedCell = UICollectionViewCell()
    
    private let collectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumLineSpacing = 40
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.backgroundColor = UIColor(named: "Light Blue")
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //First, set cell to starting position when off screen
        let rotation = CATransform3DMakeRotation(CGFloat.pi/3, 0, 0.5, 0)
        let rotationInverse = CATransform3DMakeRotation(-CGFloat.pi/3, 0, 0.5, 0)
        
        let translation = CATransform3DMakeTranslation(50, 0, 0)
        let translationInverse = CATransform3DMakeTranslation(-50, 0, 0)
        
        let scale = CATransform3DMakeScale(0.8, 0.8, 0.8)
        
        let direction = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if direction.x > 0 { // Scrolling left to right
            cell.layer.transform = rotationInverse
            cell.layer.transform = translationInverse
            cell.layer.transform = scale
        } else { // Scrolling right to left
            cell.layer.transform = rotation
            cell.layer.transform = translation
            cell.layer.transform = scale
        }
        // Then, reset back to original position
        UIView.animate(withDuration: 0.3) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = collectionView.cellForItem(at: indexPath)!
        
        let vc = CollectionViewCellDetailViewController()
        let model = viewModels[indexPath.row]
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.view.setGradientBackground(id: model.id)
        vc.view.layer.sublayers?[0].cornerRadius = 0
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.findNavigationController()?.present(nav, animated: true)
        
    }
    
    
    func configure(with viewModel: CarouselViewCellViewModel) {
        
        self.viewModels = viewModel.viewModels
        let month = Calendar.current.component(.month, from: Date())
        self.viewModels.rotate(array: &self.viewModels, k: -(month-1)) // rotate viewModels so that first month is current month
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 220
        let height: CGFloat = 300
        return CGSize(width: width, height: height)
    }
    
}

//extension CarouselViewCell: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = PresentAnimator(originFrame: selectedCell.frame)
//        print("Presenting")
//        return animator
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = DismissAnimator(destinationFrame: selectedCell.frame)
//        print("Dismissing")
//        return animator
//    }
//}
