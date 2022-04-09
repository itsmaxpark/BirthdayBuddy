//
//  BetterAddBirthdayViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/5/22.
//

import UIKit

class BetterAddBirthdayViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persons: [Person]?
    var birthdayText: String = ""
    var birthdayDate: Date = Date()
    var isSwitchOn: Bool = false
    var birthdaySection: Section = Section()
    lazy var imagePicker = UIImagePickerController() // initialize only once
    var chosenImage: UIImage?
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
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 24)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        view.addSubview(pictureBackgroundView)
        pictureBackgroundView.addSubview(pictureView)
        pictureBackgroundView.addSubview(changePictureButton)
        changePictureButton.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.setupHideKeyboardOnTap()
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
        do {
            self.persons = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching Person")
        }
    }
    
// MARK: Selectors
    @objc func didTapDone() {
        // save to core date
        // Create new person object
        guard let field = textFieldViewModels[0].text, !field.isEmpty else {
            alertFirstName()
            return
        }
        let person = Person(context: self.context)
        person.firstName = textFieldViewModels[0].text
        person.lastName = textFieldViewModels[1].text
        person.birthday = birthdayDate
        let nextBirthday = getNextBirthday(date: person.birthday!)
        let daysLeft = Calendar.current.numberOfDaysBetween(Date(), and: nextBirthday)
        person.daysLeft = Int64(daysLeft)
        let imageData = self.chosenImage?.jpegData(compressionQuality: 1.0)
        person.picture = imageData
        // Save object to CoreData
        
        do {
            try self.context.save()
        } catch {
            print("Error saving to CoreData")
        }
//        self.delegate?.refreshCollectionView()
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            if birthdaySection.isOpen {
                return 3 // 3 table cells are needed to account for the title section
            } else {
                return 1
            }
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
                    cell.configure(date: birthdayText)
                    return cell
                case 1: // DatePickerCell
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DatePickerCell.identifier,
                        for: indexPath
                    ) as? DatePickerCell else {
                        fatalError()
                    }
                    cell.customDelegate = self
                    cell.isYearShowing = self.isSwitchOn
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
                cell.configure(date: birthdayText)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            birthdaySection.isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        } else if indexPath.section == 0 {
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
    func pickerViewSetText(value: String) {
        self.birthdayText = value
        tableView.reloadData()
    }
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
extension BetterAddBirthdayViewController: YearToggleCellDelegate {
    func switchChanged(cell: YearToggleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? YearToggleCell else { fatalError() }
        cell.isOn.toggle()
        self.isSwitchOn.toggle()
        tableView.reloadData()
    }
}
