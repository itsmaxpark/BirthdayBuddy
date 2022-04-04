//
//  HomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import CoreData

class BetterHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var persons: [Person]?
    
    let sections = ["Large", "Small"]
    var collectionView: UICollectionView!
    
    var dataSource = "" // Our Person Data Objects
    
    public var selectedCell = UITableViewCell()
    
    private var viewModels: [CollectionViewCellViewModel] = [
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.register(LargeCollectionViewCell.self, forCellWithReuseIdentifier: LargeCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        
        fetchPerson()
        let month = Calendar.current.component(.month, from: Date())
        self.viewModels.rotate(array: &self.viewModels, k: -(month-1)) // rotate viewModels so that first month is current month
        collectionView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refetch data because a new birthday may be added on viewWillAppear
        fetchPerson()
        self.collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 1:
            return persons?.count ?? 0
        default:
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
            sectionHeader.title.text = "Upcoming Birthdays"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            //Large Cells
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCollectionViewCell.identifier, for: indexPath) as? LargeCollectionViewCell else {
                fatalError()
            }
            
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
        } else {
            //Small Cells
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCollectionViewCell.identifier, for: indexPath) as? SmallCollectionViewCell else {
                fatalError()
            }
            //Gradient Color is dependent on the month of the Person's birthday
            let person = persons?[indexPath.row]
            let date = person?.birthday
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: date!)
            let month = components.month
            cell.setGradientBackground(id: month!)
            cell.configure(person: person!)
            return cell
        }
    }
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            
            switch section {
            case "Small":
                return self.createSmallSection(using: section)
            default:
                return self.createLargeSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createLargeSection(using section: String) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
    
    func createSmallSection(using section: String) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.75))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func fetchPerson() {
        do {
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let sort = NSSortDescriptor(key: "daysLeft", ascending: true)
            request.sortDescriptors = [sort]
            
            self.persons = try context.fetch(request)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch {
            print("Error fetching Person")
        }
    }
    
    func getCurrentMonth() -> Int {
        return Calendar.current.component(.month, from: Date())
    }
    
}
