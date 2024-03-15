//
//  AddColdClientViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.01.2024.
//

import UIKit

final class AddColdClientViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager.shared
    
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Наименование:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var telephoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите наименование"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var telephoneTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите телефон"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите email"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupConstraint()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(telephoneLabel)
        view.addSubview(telephoneTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новый холодный клиент"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
        //navigationItem.backButtonTitle = "Назад"
    }
    
    func setupConstraint() {        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            telephoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            telephoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            telephoneLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            
            telephoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            telephoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            telephoneTextField.topAnchor.constraint(equalTo: telephoneLabel.bottomAnchor, constant: 5),
            telephoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailLabel.topAnchor.constraint(equalTo: telephoneTextField.bottomAnchor, constant: 20),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func validEmail(email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validEmail = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return validEmail.evaluate(with: email)
    }
    
    private func formatNumberPhone(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
    
    @objc func saveButtonClicked() {
        let nameColdClient = nameTextField.text ?? ""
        let telephoneColdClient = telephoneTextField.text ?? ""
        let emailColdClient = emailTextField.text ?? ""
        
        if nameColdClient.isEmpty {
            nameTextField.shake()
        } else if telephoneColdClient.isEmpty && emailColdClient.isEmpty {
            telephoneTextField.shake()
            emailTextField.shake()
        } else if !telephoneColdClient.isEmpty && telephoneColdClient.count != 18 {
            telephoneTextField.shake()
        } else if !emailColdClient.isEmpty && !validEmail(email: emailColdClient) {
            emailTextField.shake()
        } else {
            var jsonArray = [[String: String]]()
            
            if !nameColdClient.isEmpty {
                jsonArray.append(["name": nameColdClient])
            }
            if !telephoneColdClient.isEmpty {
                jsonArray.append(["tel": telephoneColdClient])
            }
            if !emailColdClient.isEmpty {
                jsonArray.append(["email": emailColdClient])
            }
            
            let json: [String: String] = [
                "name" : nameColdClient,
                "tel" : telephoneColdClient,
                "email" : emailColdClient
            ]
            
            if jsonArray.count > 1 {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return }
                networkManager.postCreateColdClient(jsonData: jsonData ) { uuid in
                    
                    DispatchQueue.main.async {
                        if uuid != "" {
                            let coldClient = ColdClient(uuid: uuid, name: nameColdClient)
                            self.coreDataManager.saveColdClient(coldClients: [coldClient]) {
                                self.coreDataManager.saveContext()
                            }
                            
                            if !telephoneColdClient.isEmpty {
                                let telephoneColdClientCntext = ContactDetailsColdClient(kind: "Телефон", presentation: telephoneColdClient, owner_uuid: uuid)
                                self.coreDataManager.saveContactDetailsColdClient(contactDetailsColdClients: [telephoneColdClientCntext]) {
                                    self.coreDataManager.saveContext()
                                }
                            }
                            if !emailColdClient.isEmpty {
                                let emailColdClientCntext = ContactDetailsColdClient(kind: "Электронная почта", presentation: emailColdClient, owner_uuid: uuid)
                                self.coreDataManager.saveContactDetailsColdClient(contactDetailsColdClients: [emailColdClientCntext]) {
                                    self.coreDataManager.saveContext()
                                }
                            }
                            
                            let alert = UIAlertController(title: "Новый холодный клиент сохранен", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                                //let coldClientsViewController = ColdClientsViewController()
                                //self.navigationController?.pushViewController(coldClientsViewController, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Ошибка \(uuid)", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                                //let coldClientsViewController = ColdClientsViewController()
                                //self.navigationController?.pushViewController(coldClientsViewController, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                }
            }
                
            
            
        }
    }
    
    @objc func closeButtonClicked() {
        let alert = UIAlertController(title: "Все не сохраненные данные будут потеряны, хотите закрыть?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
            //let partnersViewController = PartnersViewController()
            //self.navigationController?.pushViewController(partnersViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        nameTextField.resignFirstResponder()
        telephoneTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
}

extension AddColdClientViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = formatNumberPhone(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}
