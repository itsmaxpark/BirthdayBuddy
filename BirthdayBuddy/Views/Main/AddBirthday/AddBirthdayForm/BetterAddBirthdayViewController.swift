//
//  BetterAddBirthdayViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/5/22.
//

import UIKit

class BetterAddBirthdayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, YearToggleCellDelegate, CustomPickerViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var persons: [Person]?
    
    let placeholderText: [String] = ["First Name", "Last Name"]
    
    var birthdayText: String = ""
    
    struct Section {
        var isOpen: Bool = false
    }
    
    var isSwitchOn: Bool = false
    
    var birthdaySection: Section = Section()
    
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
        table.register(AddBirthdayTextFieldCell.self, forCellReuseIdentifier: AddBirthdayTextFieldCell.identifier)
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
                withIdentifier: AddBirthdayTextFieldCell.identifier,
                for: indexPath
            ) as? AddBirthdayTextFieldCell else {
                fatalError()
            }
            cell.placeholder = placeholderText[indexPath.row]
            return cell
        case 1:
            if birthdaySection.isOpen {
                switch indexPath.row {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: BirthdayCell.identifier,
                        for: indexPath
                    ) as? BirthdayCell else {
                        fatalError()
                    }
                    cell.configure(date: birthdayText)
                    return cell
                case 1:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DatePickerCell.identifier,
                        for: indexPath
                    ) as? DatePickerCell else {
                        fatalError()
                    }
                    cell.customDelegate = self
                    cell.isYearShowing = self.isSwitchOn
                    return cell
                default:
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Index Path \(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            birthdaySection.isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if birthdaySection.isOpen {
                if indexPath.row == 1 {
                    return 200
                }
            }
        }
        return 44
    }
    
    func switchChanged(cell: YearToggleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? YearToggleCell else { fatalError() }
        cell.isOn.toggle()
        self.isSwitchOn.toggle()
        tableView.reloadData()
    }
    
    func pickerViewDidChange(value: String) {
        self.birthdayText = value
        tableView.reloadData()
        print(birthdayText)
    }
    
    
    @objc func didTapDone() {
        // save to core date
    }
    @objc func didTapCancel() {
        // Dismisses the bottomSheet view controller with BetterAddBirthdayVC
        self.dismiss(animated: true)
    }
    @objc func didTapChange() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Take or Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    @objc func switchToggled(cell: YearToggleCell) {
        print("YOOOO")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        pictureView.image = image
        
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
