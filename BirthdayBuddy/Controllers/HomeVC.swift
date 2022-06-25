//
//  HomeViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase

class HomeVC: UIViewController {
    
    private var persons: [Person]?
    private let sections = ["Large", "Small"]
    private var viewModels = CalendarMonthViewModels.viewModels
    private let calendar = Calendar(identifier: .gregorian)
    private var dateFormatter = CustomDateFormatter()
    private var selectedDate: Date = Date()
    private var monthData: [[CalendarDay]] = []
    
    public var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.shared.fetchPerson({ [weak self] newPersons in
            guard let self = self else { return }
            self.persons = newPersons
            self.monthData = CalendarManager.shared.getMonthData()
            self.collectionView.reloadData()
        })
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        view.addSubview(collectionView)
        
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .tertiarySystemBackground
        collectionView.alwaysBounceVertical = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.register(LargeCollectionViewCell.self, forCellWithReuseIdentifier: LargeCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        
        viewModels.rotate(array: &viewModels, k: -(calendar.getCurrentMonth()-1)) // rotate viewModels so that first month is current month
    }
    
    public func getNumberOfBirthdays() -> String {
        return "There are \(persons!.count) birthdays on your account"
    }
}

// MARK: - Collection View Delegate and Data Source
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return 2 // Small and Large Section
        } else {
            return 6 // Calendar Section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            let type = sections[section]
            switch type {
            case "Small":
                return persons?.count ?? 0
            default :
                return viewModels.count
            }
        } else {
            return 7 // Days in a week
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
            sectionHeader.title.text = "Upcoming Birthdays"
            sectionHeader.title.textColor = .label
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let largeCell = cell as? LargeCollectionViewCell else { return }
        largeCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            if indexPath.section == 0 {
                //Large Cells
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LargeCollectionViewCell.identifier,
                    for: indexPath
                ) as? LargeCollectionViewCell else { fatalError() }
                
                let model = viewModels[indexPath.row]
                cell.configure(with: model)

                return cell
            } else {
                //Small Cells
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallCollectionViewCell.identifier,
                    for: indexPath
                ) as? SmallCollectionViewCell else { fatalError() }
                guard let person = persons?[indexPath.row] else { fatalError() }
                
                cell.configure(person: person)
                
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCollectionViewCell.identifier,
                for: indexPath
            ) as? CalendarCollectionViewCell else { fatalError() }
            
            let monthIndex = collectionView.tag
            let monthRow = indexPath.section
            let monthColumn = indexPath.item
            let isIndexValid = monthData.indices.contains(monthIndex)
            
            if isIndexValid {
                let cellMonth = self.monthData[monthIndex]
                let cellPosition = (monthRow*7) + monthColumn
                let cellDay: CalendarDay = cellMonth[cellPosition]
                if cellDay.isSelected {
                    cell.isActive = true
                } else {
                    cell.isActive = false
                }
                cell.configure(with: cellDay)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { // SmallCollectionViewCell
            // Present AddBirthdayViewController in Edit Mode
            let person = persons![indexPath.row]
            let vc = AddBirthdayVC()
            vc.delegate = self
            vc.chosenPerson = person
            vc.isEditModeOn = true
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
    }
}

// MARK: - Flow Layout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(collectionView.bounds.width/7), height: floor(collectionView.bounds.height/6))
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
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(340))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        return layoutSection
    }
    
    func createSmallSection(using section: String) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.7))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
}

extension HomeVC: AddBirthdayViewControllerDelegate {
    func refreshCollectionView() {
        DatabaseManager.shared.fetchPerson({ [weak self] newPersons in
            guard let self = self else { return }
            self.persons = newPersons
            self.monthData = CalendarManager.shared.getMonthData()
            self.collectionView.reloadData()
        })
    }
}
