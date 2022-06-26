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

class AddBirthdayVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    struct Section {
        var isOpen: Bool = false
    }
    
    weak var delegate: AddBirthdayViewControllerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var textFieldViewModels = TextFieldCellViewModels.viewModels
    private var persons: [Person]?
    private var birthdaySection: Section = Section()
    private var isCalendarSwitchOn: Bool = false
    private var isNotificationSwitchOn: Bool = true
    private var imagePicker = UIImagePickerController()
    private var chosenImage: UIImage?
    private var birthdayText: String?
    private var birthdayDate: Date?  = Date() {
        didSet {
            if isCalendarSwitchOn {
                birthdayText = birthdayDate?.getString(components: [.month, .day, .year]) ?? ""
            } else {
                birthdayText = birthdayDate?.getString(components: [.month, .day]) ?? ""
            }
            tableView.reloadData()
        }
    }
    
    public var chosenPerson: Person?
    public var isEditModeOn: Bool = false
    
    // MARK: - UI Components
    private let pictureBackgroundView = BBView(backgroundColor: .systemBackground, isAutoLayoutOff: false)
    private let pictureView = BBImageView(image: Image.person, cornerRadius: 60, clipsToBounds: true, contentMode: .scaleAspectFill)
    private let changePictureButton = BBButton(titleColor: .systemBlue, title: "Change Photo", font: UIFont.appFont(name: "Rubik", size: 20))
    private let firstNameField = BBTextField(placeholder: "First Name")
    private let lastNameField = BBTextField(placeholder: "Last Name")
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
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
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.chosenImage != nil {
            pictureView.image = self.chosenImage
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        self.setupHideKeyboardOnTap()
        
        if isEditModeOn {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
            editModeSetup()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    }
    
    private func configureUI() {
        view.addSubviews(pictureBackgroundView, changePictureButton, tableView)
        pictureBackgroundView.addSubview(pictureView)
        changePictureButton.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            pictureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pictureView.widthAnchor.constraint(equalToConstant: view.width/3),
            pictureView.heightAnchor.constraint(equalToConstant: view.width/3),
            
            changePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            changePictureButton.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10),
            changePictureButton.widthAnchor.constraint(equalTo: pictureView.widthAnchor, multiplier: 1.2),
            
            tableView.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func fetchPerson() {
        self.delegate?.refreshCollectionView()
    }
    
    private func editModeSetup() {
        guard let person = chosenPerson else { return }
        let data = person.picture
        
        if data == nil {
            pictureView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            pictureView.image = UIImage(data: data!)
            chosenImage = pictureView.image
        }
        textFieldViewModels[0].text = person.firstName
        textFieldViewModels[1].text = person.lastName
        birthdayDate = person.birthday
        isNotificationSwitchOn = person.hasNotifications
    }
    
// MARK: - Selectors
    @objc private func didTapSave() {
        guard var person = chosenPerson else { return }
        guard let field = textFieldViewModels[0].text, !field.isEmpty else {
            presentBBAlert(title: "Whoops", message: "Please enter a first name", buttonTitle: "Ok")
            return
        }
        
        person.firstName = textFieldViewModels[0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
        person.lastName = textFieldViewModels[1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
        person.birthday = birthdayDate
        
        let nextBirthday = getNextBirthday(date: person.birthday!)
        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
        person.daysLeft = Int64(daysLeft)
        
        let imageData = chosenImage?.jpegData(compressionQuality: 1.0)
        person.picture = imageData
        
        if isNotificationSwitchOn {
            NotificationManager.shared.createBirthdayNotification(person: person)
            person.hasNotifications = true
        } else {
            NotificationManager.shared.removeNotification(person: person)
            person.hasNotifications = false
        }
        // Update data in Firebase
        DatabaseManager.shared.updateBirthday(for: person) { result in
            switch result {
            case .success():
                self.delegate?.refreshCollectionView()
                self.dismiss(animated: true)
            case .failure(_):
                break
            }
        }
        self.dismiss(animated: true)
    }
    
    @objc private func didTapDone() {
        guard let field = textFieldViewModels[0].text, !field.isEmpty else {
            presentBBAlert(title: "Whoops", message: "Please enter a first name", buttonTitle: "Ok")
            return
        }
        
        let firstName = textFieldViewModels[0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = textFieldViewModels[1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
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
            person.hasNotifications = false
        }
        // Save to Firebase Database
        DatabaseManager.shared.addBirthday(for: person) { result in
            switch result {
            case .success():
                self.delegate?.refreshCollectionView()
                self.dismiss(animated: true) {
                    print("in dismiss")
                    self.navigationController!.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("didTapDone: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func didTapCancel() {
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

// MARK: - TableView Delegate and Data Source
extension AddBirthdayVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isEditModeOn { return 4 } else { return 3 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: if birthdaySection.isOpen { return 3 } else { return 1 }
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as! TextFieldCell
            cell.delegate = self
            cell.configure(with: textFieldViewModels[indexPath.row])
            
            return cell
            
        case 1:
            if birthdaySection.isOpen {
                switch indexPath.row {
                case 0: // BirthdayCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayCell.identifier, for: indexPath) as! BirthdayCell
                    cell.configure(date: birthdayText ?? "")
                    
                    return cell
                    
                case 1: // DatePickerCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.identifier, for: indexPath) as! DatePickerCell
                    cell.customDelegate = self
                    cell.showYear = isCalendarSwitchOn
                    cell.setupDatePicker(date: self.birthdayDate ?? Date())
                    
                    return cell
                    
                default: // YearToggleCell
                    let cell = tableView.dequeueReusableCell(withIdentifier: YearToggleCell.identifier, for: indexPath) as! YearToggleCell
                    cell.delegate = self
                    
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: BirthdayCell.identifier, for: indexPath) as! BirthdayCell
                cell.configure(date: birthdayText ?? "")
                
                return cell
            }
            
        case 2: // Notifications Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsCell.identifier, for: indexPath) as! NotificationsCell
            cell.delegate = self
            if isEditModeOn { cell.configure(isNotificationSwitchOn) }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeleteButtonCell.identifier, for: indexPath) as! DeleteButtonCell
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
            let cell = tableView.cellForRow(at: indexPath) as! TextFieldCell
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && birthdaySection.isOpen && indexPath.row == 1 { return 200 }
        return 44
    }
}

// MARK: - CustomPickerViewDelegate
extension AddBirthdayVC: CustomPickerViewDelegate {
    
    func pickerViewSetDate(date: Date) {
        self.birthdayDate = date
    }
    
    func getNextBirthday(date: Date) -> Date {
        let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        var birthday = Calendar.current.dateComponents([.day,.month,.year], from: date)
        birthday.year = currentDate.year
        let numberOfDays = Calendar.current.dateComponents([.day], from: currentDate, to: birthday).day!
        if numberOfDays < 0 {
            birthday.year! += 1
        }
        let nextBirthday = Calendar.current.date(from: birthday)
        
        return nextBirthday!
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddBirthdayVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.pictureView.image = self.chosenImage
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

// MARK: - TextFieldCellDelegate
extension AddBirthdayVC: TextFieldCellDelegate {
    
    func didEditTextField(textField: UITextField) {
        if textField.placeholder == "First Name" {
            textFieldViewModels[0].text = textField.text
        } else {
            textFieldViewModels[1].text = textField.text
        }
    }
}
// MARK: - YearToggleDelegate
extension AddBirthdayVC: YearToggleCellDelegate {
    
    func switchChanged(cell: YearToggleCell) {
        isCalendarSwitchOn.toggle()
        pickerViewSetDate(date: birthdayDate!) // refresh date text when year is toggled
    }
}

// MARK: - NotificationsCellDelegate
extension AddBirthdayVC: NotificationsCellDelegate {
    
    func switchChanged(cell: NotificationsCell) {
        isNotificationSwitchOn.toggle()
        tableView.reloadData()
    }
}

// MARK: - DeleteButtonDelegate
extension AddBirthdayVC: DeleteButtonCellDelegate {
    
    func didTapDelete(cell: DeleteButtonCell) {
        guard let person = self.chosenPerson else { return }
        
        let message = "Remove \(person.firstName ?? "") \(person.lastName ?? "") from Birthday Buddy"
        let alert = UIAlertController(title: "Delete", message: message, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            // remove notification
            NotificationManager.shared.removeNotification(person: person)
            // remove person
            person.ref?.removeValue()
            // remove image from firebase storage
            DatabaseManager.shared.deletePicture(for: person)
            // refresh collection view
            self.delegate?.refreshCollectionView()
            self.dismiss(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
}

