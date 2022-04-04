//
//  AddBirthdayViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 3/7/22.
//

import UIKit
import CoreData

class AddBirthdayViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var persons: [Person]?
    
    private let addBirthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Birthday"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = .black
        return label
    }()
    
    private let backgroundAddView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(named: "Light Blue")
        
        return view
    }()
    
    private let pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")

        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = CustomDesigns.shared.createCustomTextField(
            previewText: "First Name",
            isSecure: false
        )
        field.autocapitalizationType = .words
        return field
    }()
    private let lastNameField: UITextField = {
        let field = CustomDesigns.shared.createCustomTextField(
            previewText: "Lsat Name",
            isSecure: false
        )
        field.autocapitalizationType = .words
        return field
    }()
    
    private let dateTextField: UITextField = {
        let field = UITextField()
        
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(
            string: "Birthday",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)
            ]
        )
        field.textColor = .black
        field.backgroundColor = .white
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 20
        datePicker.layer.masksToBounds = true
        if let bgView = datePicker.subviews.first?.subviews.first?.subviews.first {
            bgView.backgroundColor = .clear
        }
        return datePicker
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(name: "IndieFlower", size: 36)
        button.setTitle("Ok", for: .normal)
        return button
    }()
    
    // MARK: - Recently Added
    
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recently Added"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = .black
        return label
    }()
    
    private let backgroundTableView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(named: "Light Blue")
        
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            PersonTableViewCell.self,
            forCellReuseIdentifier: PersonTableViewCell.identifier
        )
        table.rowHeight = 80
        table.backgroundColor = .clear
        table.separatorColor = .clear
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.text = formatDate(date: Date())
        
        view.addSubview(addBirthdayLabel)
        view.addSubview(backgroundAddView)
        view.addSubview(pictureView)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(datePicker)
        view.addSubview(addButton)
        
        view.addSubview(recentLabel)
        view.addSubview(backgroundTableView)
        backgroundTableView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        fetchPerson()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addBirthdayLabel.frame = CGRect(
            x: 30,
            y: view.top+100,
            width: 400,
            height: 50
        )
        backgroundAddView.frame = CGRect(
            x: 30,
            y: view.top+150,
            width: view.width-60,
            height: (view.height/2)-60
        )
        pictureView.frame = CGRect(
            x: backgroundAddView.center.x-(150/2),
            y: backgroundAddView.top+20,
            width: 150,
            height: 150
        )
        firstNameField.frame = CGRect(
            x: backgroundAddView.center.x-(250/2),
            y: pictureView.bottom+20,
            width: 250,
            height: 40
        )
        lastNameField.frame = CGRect(
            x: backgroundAddView.center.x-(250/2),
            y: firstNameField.bottom+10,
            width: 250,
            height: 40
        )
        datePicker.frame = CGRect(
            x: backgroundAddView.center.x-(250/2),
            y: lastNameField.bottom+20,
            width: 250,
            height: 45
        )
        addButton.frame = CGRect(
            x: backgroundAddView.center.x-(250/2),
            y: datePicker.bottom+10,
            width: 250,
            height: 45
        )
        
        // MARK: - Recently Added Frames
        
        recentLabel.frame = CGRect(
            x: 30,
            y: backgroundAddView.bottom,
            width: 400,
            height: 50
        )
        backgroundTableView.frame = CGRect(
            x: 30,
            y: recentLabel.bottom,
            width: view.width-60,
            height: 200
        )
        tableView.frame = CGRect(
            x: 10,
            y: 10,
            width: backgroundTableView.width-20,
            height: backgroundTableView.height-20
        )
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = formatDate(date: datePicker.date)
    }
    
    @objc func didTapAdd() {
        // Create new person object
        guard let field = firstNameField.text, !field.isEmpty else {
            alertFirstName()
            return
        }
        
        let person = Person(context: self.context)
        person.firstName = firstNameField.text
        person.lastName = lastNameField.text
        person.birthday = datePicker.date
        
        // Save object to CoreData
        do {
            try self.context.save()
        } catch {
            print("Error saving to CoreData")
        }
        
        // Repopulate persons array
        self.fetchPerson()
        
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

extension AddBirthdayViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            self.view.endEditing(true)
        }
        return true
    }
}

extension AddBirthdayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PersonTableViewCell.identifier,
            for: indexPath
        ) as? PersonTableViewCell else {
            fatalError()
        }
        
        guard let person = self.persons?[indexPath.row] else {
            fatalError()
        }
            
        cell.configure(person: person)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select person
        let person = self.persons![indexPath.row]
        // create alert
        
        let message = "Remove \(person.firstName!) \(person.lastName!) from Birthday Buddy"
        
        let alert = UIAlertController(title: "Delete", message: message, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            // remove person
            self.context.delete(person)
            // save data
            do {
                try self.context.save()
            } catch {
                print("Error deleting person")
            }
            // refetch data
            self.fetchPerson()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    @objc func dateAlertChange(datePicker: UIDatePicker, textField: UITextField) {
        textField.text = formatDate(date: datePicker.date)
    }
    
    func alertFirstName() {
        let alert = UIAlertController(title: "Whoops", message: "Please enter a first name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true)
    }
}
