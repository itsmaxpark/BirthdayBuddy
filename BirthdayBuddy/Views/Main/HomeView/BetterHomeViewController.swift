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

class BetterHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var persons: [Person]? {
        didSet {
            print("person count: \(persons?.count ?? 0)")
        }
    }
    let sections = ["Large", "Small"]
    var collectionView: UICollectionView!
    
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
    
//    private let birthdayRef: DatabaseReference = {
//        let uid = Auth.auth().currentUser?.uid
//        let ref = DatabaseManager.shared.usersRef.child("\(uid!)/birthdays")
//        return ref
//    }()
    
    private var refObservers: [DatabaseHandle] = []
    
    private let calendar = Calendar(identifier: .gregorian)
    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()
    private var selectedDate: Date = Date()
    private var monthData: [[CalendarDay]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = .tertiarySystemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(didTapBell))
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.register(LargeCollectionViewCell.self, forCellWithReuseIdentifier: LargeCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        
        self.viewModels.rotate(array: &self.viewModels, k: -(getCurrentMonth()-1)) // rotate viewModels so that first month is current month
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refetch data because a new birthday may be added on viewWillAppear
        
        fetchPerson { newPersons in
//            self.persons = []
//            self.persons = newPersons
            print("Inside Completion handler")
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        refObservers.forEach(birthdayRef.removeObserver(withHandle:))
        refObservers = []
    }
    
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
                ) as? LargeCollectionViewCell else {
                    fatalError()
                }
                let model = viewModels[indexPath.row]
                cell.configure(with: model)

                return cell
            } else {
                //Small Cells
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallCollectionViewCell.identifier,
                    for: indexPath
                ) as? SmallCollectionViewCell else {
                    fatalError()
                }
                guard let person = persons?[indexPath.row] else { fatalError() }
                cell.configure(person: person)
                
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCollectionViewCell.identifier,
                for: indexPath
            ) as? CalendarCollectionViewCell else {
                fatalError()
            }
            let monthIndex = collectionView.tag
            let monthRow = indexPath.section
            let monthColumn = indexPath.item
            
            let cellMonth: [CalendarDay] = self.monthData[monthIndex]
            let cellPosition = (monthRow*7) + monthColumn
            let cellDay: CalendarDay = cellMonth[cellPosition]
            if cellDay.isSelected {
                cell.isActive = true
            } else {
                cell.isActive = false
            }
            cell.configure(with: cellDay, with: monthIndex)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { // SmallCollectionViewCell
            // Present AddBirthdayViewController in Edit Mode
            let person = persons![indexPath.row]
            let vc = BetterAddBirthdayViewController()
            vc.delegate = self
            vc.chosenPerson = person
            vc.isEditModeOn = true
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        }
    }
    
    
    /// fetches all Person models sorted by daysLeft, sets up the Calendar, and saves an array of models
    func fetchPerson(_ completion: @escaping (([Person]) -> Void)) {
        // add listener when database changes
        print()
        print("Fetching Person")
        getMonthData()
        var newPersons: [Person] = []
//        persons = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let birthdayRef = DatabaseManager.shared.usersRef.child("\(uid)/birthdays")
        
        birthdayRef
            .queryOrdered(byChild: "daysLeft")
            .observeSingleEvent(of: .value) { snapshot in
            print("Value changed")
            let group = DispatchGroup()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   var person = Person(snapshot: snapshot) {
                    // fetch picture from database storage
                    group.enter()
                    print("ENTER")
                    
                    self.fetchPicture(for: person) { data in
                        print("Fetched picture")
                        person.picture = data
                        newPersons.append(person)
                        
                        print("LEAVE")
                        group.leave()
                    }
                } else {
                    print("Error creating person object with snapshot")
                    print("LEAVE")
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                //                self.persons = []
                print("NOTIFY")
//                print(newPersons)
                self.persons = newPersons
                completion(newPersons)
                print("Collection reloaded in dispatch group")
            }
        }
//        refObservers.append(completed)
        //            updateDaysLeft()
    }
    
    func fetchPicture(for person: Person, completion: @escaping ((Data?) -> Void)) {
        guard let personID = person.id else {
            print("error geting person id")
            return
        }
        // Check if pictureURL exists
        var imageData: Data?
        guard let uid = Auth.auth().currentUser?.uid else {
            print("error getting uid")
            return
        }
        let birthdayRef = DatabaseManager.shared.usersRef.child("\(uid)/birthdays")
        birthdayRef.child("\(personID)/pictureURL").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                guard let urlString = snapshot.value as? String else {
                    print("error getting url")
                    return
                }
                guard let url = URL(string: urlString) else {
                    print("error converting string to url")
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    imageData = data
                    completion(imageData)
                }
                task.resume()
            } else {
                completion(nil)
            }
        }
    }
    
    /// fetches all Person models, updates daysLeft attribute, saves back to Core Data
    func updateDaysLeft() {
//        do {
//            let request = Person.fetchRequest() as NSFetchRequest<Person>
//            let personModels = try context.fetch(request)
//            for person in personModels {
//                let nextBirthday = getNextBirthday(date: person.birthday!)
//                let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
//                person.daysLeft = Int64(daysLeft)
//            }
//            try self.context.save()
//        } catch {
//            print("Error fetching Person")
//        }
    }

}

// MARK: Flow Layout
extension BetterHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(collectionView.bounds.width/7), height: collectionView.height/6)
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
}
// MARK: CalendarSetup
extension BetterHomeViewController {
    enum CalendarDataError: Error {
        case metadataGeneration
    }
    // Accepts a date and returns a MonthMetadata
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // get number of days in month
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        // A number that represents which day (1-7) the first day is on
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    // Accepts a Date and returns an array of CalendarDay objects
    func generateDaysInMonth(for baseDate: Date) -> [CalendarDay] {
        // Retrieve metadata for a month
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        // Offset the Month's start position if first day of month is not a Sunday
        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            // Check if current day is from previous or current month
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            // Calculate the offset from current day to first day of month
            let dayOffset = isWithinDisplayedMonth ? day-offsetInInitialRow : -(offsetInInitialRow-day)
            // Create a CalendarDay
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        days += generateStartOfNextMonth(using: firstDayOfMonth, using: offsetInInitialRow, using: numberOfDaysInMonth)
        return days
    }
    func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool ) -> CalendarDay {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate
        ) ?? baseDate
        
        return CalendarDay(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: checkIfDateExists(date: date),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    // Takes in the first day of current month and returns an array of CalendarDay
    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date,
        using firstDayWeekDay: Int,
        using numberOfDaysInMonth: Int
    ) -> [CalendarDay] {
        guard let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth
        ) else {
            return []
        }
        // Gets how many days we need to add to end of the current month to fill last row/rows
        // ie) if last day is Saturday, additionalDays = 7
        var additionalDays: Int
        if firstDayWeekDay + numberOfDaysInMonth > 36 {
            additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        } else {
            additionalDays = 14 - calendar.component(.weekday, from: lastDayInMonth)
        }
        guard additionalDays > 0 else {
            return []
        }
        // Generate the start of next month
        let days: [CalendarDay] = (1...additionalDays).map {
            generateDay(
                offsetBy: $0,
                for: lastDayInMonth,
                isWithinDisplayedMonth: false
            )
        }
        return days
    }
    func isSameMonthAndDay(date1: Date, date2: Date) -> Bool {
        let oldFirstDate = Calendar.current.dateComponents([.day, .month, .year], from: date1)
        let oldSecondDate = Calendar.current.dateComponents([.day, .month, .year], from: date2)
        var firstDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        var secondDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        firstDate.month = oldFirstDate.month
        secondDate.month = oldSecondDate.month
        firstDate.day = oldFirstDate.day
        secondDate.day = oldSecondDate.day
        let newFirstDate = Calendar.current.date(from: firstDate)
        let newSecondDate = Calendar.current.date(from: secondDate)
        let isDayEqual = Calendar.current.isDate(newFirstDate!, equalTo: newSecondDate!, toGranularity: .day)
        let isMonthEqual = Calendar.current.isDate(newFirstDate!, equalTo: newSecondDate!, toGranularity: .month)
        if isDayEqual && isMonthEqual {
            return true
        }
        return false
    }
    func checkIfDateExists(date: Date) -> Bool {
//        guard let allPersons = self.persons else { fatalError() }
//        for person in allPersons {
//            let birthday = person.birthday!
//            if isSameMonthAndDay(date1: date, date2: birthday) {
//                return true
//            }
//        }
        return false
    }
    func getNextBirthday(date: Date) -> Date {
        // Get current date
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        // get birthday date
        var birthday = Calendar.current.dateComponents([.day,.month,.year], from: date)
        // set birthday year to current year
        birthday.year = currentDate.year
        // if birthday already happened this year, add 1 to year
        let numberOfDays = Calendar.current.dateComponents([.day], from: currentDate, to: birthday).day!
        if numberOfDays < 0 {
            birthday.year! += 1
        }
        let nextBirthday = Calendar.current.date(from: birthday)
        
        return nextBirthday!
    }
    func getMonthData() {
        print("Getting Month Data")
        var newMonthData: [[CalendarDay]] = []
        for month in 1...12 {
            var dateComponents = DateComponents()
            dateComponents.month = month
            if month < getCurrentMonth() {
                dateComponents.year = getCurrentYear() + 1
            } else {
                dateComponents.year = getCurrentYear()
            }
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: dateComponents)
            let newMonth = self.generateDaysInMonth(for: date!)
            newMonthData.append(newMonth)
        }
        self.monthData = newMonthData
        self.monthData.rotate(array: &self.monthData, k: -(getCurrentMonth()-1))
    }
    func getCurrentMonth() -> Int {
        return Calendar.current.component(.month, from: Date())
    }
    func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }
}
// MARK: Selectors
extension BetterHomeViewController {
    @objc func didTapBell() {
        NotificationManager.shared.getAllNotifications()
    }
}

extension BetterHomeViewController: AddBirthdayViewControllerDelegate {
    func refreshCollectionView() {
        fetchPerson { newPersons in
            print("RefreshCollectionView fetchperson")
//            self.persons = []
//            self.persons = newPersons
            self.collectionView.reloadData()
        }
    }
}
