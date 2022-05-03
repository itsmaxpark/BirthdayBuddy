//
//  BetterAddBirthdayViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/5/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol AddBirthdayViewControllerDelegate: AnyObject {
    func refreshCollectionView()
}

class BetterAddBirthdayViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    weak var delegate: AddBirthdayViewControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persons: [Person]?
    var birthdayText: String?
    var birthdayDate: Date? {
        didSet {
            if isCalendarSwitchOn {
                birthdayText = birthdayDate?.getString(components: [.month, .day, .year]) ?? ""
            } else {
                birthdayText = birthdayDate?.getString(components: [.month, .day]) ?? ""
            }
            tableView.reloadData()
        }
    }
    var isCalendarSwitchOn: Bool = false
    var isNotificationSwitchOn: Bool = true
    var birthdaySection: Section = Section()
    lazy var imagePicker = UIImagePickerController() // initialize only once
    var chosenImage: UIImage?
    var chosenPerson: Person?
    var isEditModeOn: Bool = false
    
    private let birthdayRef: DatabaseReference = {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError()
        }
        let ref = DatabaseManager.shared.usersRef.child("\(uid)/birthdays")
        return ref
    }()
    struct Section {
        var isOpen: Bool = false
    }
    
    private var textFieldViewModels: [TextFieldCellViewModel] = [
        TextFieldCellViewModel(text: nil, placeholder: "First Name"),
        TextFieldCellViewModel(text: nil, placeholder: "Last Name"),
    ]
    // MARK: Views
    private let pictureBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    private let changePictureButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(name: "Rubik", size: 20)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 2.0
        return button
    }()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        table.register(DatePickerCell.self, forCellReuseIdentifier: DatePickerCell.identifier)
        table.register(BirthdayCell.self, forCellReuseIdentifier: BirthdayCell.identifier)
        table.register(YearToggleCell.self, forCellReuseIdentifier: YearToggleCell.identifier)
        table.register(NotificationsCell.self, forCellReuseIdentifier: NotificationsCell.identifier)
        table.register(DeleteButtonCell.self, forCellReuseIdentifier: DeleteButtonCell.identifier)
        table.sectionHeaderHeight = 0 // space between sections
        table.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: table.frame.width, height: CGFloat.leastNormalMagnitude)
        ) // topmost header
        return table
    }()
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "First Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .systemGray
        return field
    }()
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Last Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .systemGray
        return field
    }()
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if isEditModeOn {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        view.addSubview(pictureBackgroundView)
        pictureBackgroundView.addSubview(pictureView)
        pictureBackgroundView.addSubview(changePictureButton)
        changePictureButton.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.setupHideKeyboardOnTap()
        birthdayDate = Date()
        
        if isEditModeOn {
            editModeSetup()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pictureBackgroundView.frame = CGRect(
            x: 0,
            y: navigationController?.navigationBar.bottom ?? 5,
            width: view.bounds.width,
            height: view.bounds.height/5 + 20
        )
        pictureView.frame = CGRect(
            x: pictureBackgroundView.center.x-60,
            y: pictureBackgroundView.center.y-140,
            width: 120,
            height: 120
        )
        changePictureButton.frame = CGRect(
            x: pictureView.left-20,
            y: pictureView.bottom+10,
            width: 160,
            height: 40
        )
        tableView.frame = CGRect(
            x: 0,
            y: pictureBackgroundView.bottom,
            width: view.width,
            height: view.height - pictureBackgroundView.height
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.chosenImage != nil {
            pictureView.image = self.chosenImage
        }
    }
    
    func fetchPerson() {
        print("Refreshing collection view")
        self.delegate?.refreshCollectionView()
    }
    func editModeSetup() {
        guard let person = chosenPerson else {
            print("Failed to get person")
            return
        }
        // 1. Setup picture
        let data = person.picture
        if data == nil {
            pictureView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            pictureView.image = UIImage(data: data!)
            chosenImage = pictureView.image
        }
        // 2. Setup Text Fields
        textFieldViewModels[0].text = person.firstName
        textFieldViewModels[1].text = person.lastName
        // 3. Setup Birthday Cell
        birthdayDate = person.birthday
        // 4. Setup Notifications Cell
        isNotificationSwitchOn = person.hasNotifications
    }
    
// MARK: Selectors
    @objc func didTapSave() {
        print("Did Tap Save Button")
        guard let field = textFieldViewModels[0].text, !field.isEmpty else {
            alertFirstName()
            return
        }
        guard var person = chosenPerson else {
            print("Failed to get person")
            return
        }
        person.firstName = textFieldViewModels[0].text
        person.lastName = textFieldViewModels[1].text
        print("Birthday date before save: \(birthdayDate!)")
        person.birthday = birthdayDate
        
        let nextBirthday = getNextBirthday(date: person.birthday!)
        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
        person.daysLeft = Int64(daysLeft)
        
        let imageData = chosenImage?.jpegData(compressionQuality: 1.0)
        person.picture = imageData
        
        if isNotificationSwitchOn {
            print("Has notifications")
            NotificationManager.shared.createBirthdayNotification(person: person)
            person.hasNotifications = true
        } else {
            print("No notifications created")
            NotificationManager.shared.removeNotification(person: person)
            person.hasNotifications = false
        }
        // Save object to CoreData
        do {
            try self.context.save()
//            print(person.getDetails())
        } catch {
            print("Error saving to CoreData")
        }
        fetchPerson()
        self.dismiss(animated: true)
        // Repopulate persons array
    }
    @objc func didTapDone() {
        // Create new person object
        guard let field = textFieldViewModels[0].text, !field.isEmpty else {
            alertFirstName()
            return
        }
        let firstName = textFieldViewModels[0].text
        let lastName = textFieldViewModels[1].text
        print("Birthday date before save: \(birthdayDate!)")
        let birthday = birthdayDate
        
        let imageData = self.chosenImage?.jpegData(compressionQuality: 1.0)
        
        let id = UUID()
        
        var person = Person(birthday: birthday, firstName: firstName, lastName: lastName, picture: imageData, id: id)
        
        let nextBirthday = getNextBirthday(date: person.birthday!)
        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
        person.daysLeft = Int64(daysLeft)
        
        if isNotificationSwitchOn {
            NotificationManager.shared.createBirthdayNotification(person: person)
            person.hasNotifications = true
        } else {
            print("No notifications created")
            person.hasNotifications = false
        }
//        // Save to Firebase Database
        DatabaseManager.shared.addBirthday(for: person)
        
        self.fetchPerson()
        self.dismiss(animated: true)
        // Repopulate persons array
    }
    @objc func didTapCancel() {
        // Dismisses the bottomSheet view controller with BetterAddBirthdayVC
        self.dismiss(animated: true)
    }
    @objc func didTapChange() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Take or Choose Photo", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Picture", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            } else {
                print("Camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Picture", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }

}
// MARK: TableView Methods
extension BetterAddBirthdayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isEditModeOn {
            return 4
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            if birthdaySection.isOpen {
                return 3 // 3 table cells are needed to account for the title section
            } else {
                return 1
            }
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldCell.identifier,
                for: indexPath
            ) as? TextFieldCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: textFieldViewModels[indexPath.row])
            return cell
        case 1:
            if birthdaySection.isOpen {
                switch indexPath.row {
                case 0: // BirthdayCell
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: BirthdayCell.identifier,
                        for: indexPath
                    ) as? BirthdayCell else {
                        fatalError()
                    }
                    // change birthday text based on year toggle
                    cell.configure(date: birthdayText ?? "")
                    return cell
                case 1: // DatePickerCell
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DatePickerCell.identifier,
                        for: indexPath
                    ) as? DatePickerCell else {
                        fatalError()
                    }
                    print("Inside birthday section is open\n")
                    cell.customDelegate = self
                    cell.showYear = isCalendarSwitchOn
                    cell.setupDatePicker(date: self.birthdayDate ?? Date())
//                    cell.refreshBirthdayText()
                    return cell
                default: // YearToggleCell
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: YearToggleCell.identifier,
                        for: indexPath
                    ) as? YearToggleCell else {
                        fatalError()
                    }
                    cell.delegate = self
                    return cell
                }
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: BirthdayCell.identifier,
                    for: indexPath
                ) as? BirthdayCell else {
                    fatalError()
                }
                cell.configure(date: birthdayText ?? "")
                return cell
            }
        case 2: // Notifications Cell
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsCell.identifier,
                for: indexPath
            ) as? NotificationsCell else {
                fatalError()
            }
            cell.delegate = self
            if isEditModeOn {
                cell.configure(isNotificationSwitchOn)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DeleteButtonCell.identifier,
                for: indexPath
            ) as? DeleteButtonCell else {
                fatalError()
            }
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 { // BirthdayCell
            tableView.deselectRow(at: indexPath, animated: true)
            birthdaySection.isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        } else if indexPath.section == 0 { // close birthday section when tapping outside
            if birthdaySection.isOpen {
                birthdaySection.isOpen.toggle()
                tableView.reloadData()
            }
            guard let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell else { fatalError() }
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && birthdaySection.isOpen && indexPath.row == 1 {
            return 200
        }
        return 44
    }
}
// MARK: Alerts
extension BetterAddBirthdayViewController {
    func alertFirstName() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter a first name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true)
    }
}
// MARK: CustomPickerViewDelegate
extension BetterAddBirthdayViewController: CustomPickerViewDelegate {
    func pickerViewSetDate(date: Date) {
        self.birthdayDate = date
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
}
// MARK: UIImagePickerControllerDelegate
extension BetterAddBirthdayViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.pictureView.image = self.chosenImage
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
// MARK: CropViewControllerDelegate
extension BetterAddBirthdayViewController: CropViewControllerDelegate {
    func didCropImage(image: UIImage?) {
        self.chosenImage = image
    }
}
// MARK: TextFieldCellDelegate
extension BetterAddBirthdayViewController: TextFieldCellDelegate {
    func didEditTextField(textField: UITextField) {
        if textField.placeholder == "First Name" {
            textFieldViewModels[0].text = textField.text
        } else {
            textFieldViewModels[1].text = textField.text
        }
    }
}
// MARK: YearToggleDelegate
extension BetterAddBirthdayViewController: YearToggleCellDelegate {
    func switchChanged(cell: YearToggleCell) {
        isCalendarSwitchOn.toggle()
        pickerViewSetDate(date: birthdayDate!) // refresh date text when year is toggled
    }
}
// MARK: NotificationsCellDelegate
extension BetterAddBirthdayViewController: NotificationsCellDelegate {
    func switchChanged(cell: NotificationsCell) {
        isNotificationSwitchOn.toggle()
        tableView.reloadData()
    }
}
// MARK: DeleteButtonDelegate
extension BetterAddBirthdayViewController: DeleteButtonCellDelegate {
    func didTapDelete(cell: DeleteButtonCell) {
        guard let person = self.chosenPerson else { return }
        // create alert
        
        let message = "Remove \(person.firstName ?? "") \(person.lastName ?? "") from Birthday Buddy"
        let alert = UIAlertController(title: "Delete", message: message, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            // remove notification
            NotificationManager.shared.removeNotification(person: person)
            // remove person
            
            // save data
            
            // refetch data
            self.fetchPerson()
            print("Birthday was deleted")
            self.dismiss(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
}

