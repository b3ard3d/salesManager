//
//  AddContactInfoViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 04.02.2024.
//

import UIKit

final class AddContactInfoViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    var selectedName, selectedUUID: String?
    let networkManager = NetworkManager()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
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
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Введите адрес"
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(telephoneLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(telephoneTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(addressTextField)
                        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(kbwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новые контактное лицо"
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonClicked))
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [saveButton]
        //navigationItem.backButtonTitle = "Назад"
    }
    
    func setupConstraint() {
        let heightTabBar = (self.tabBarController?.tabBar.frame.height ?? 49.0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: heightTabBar),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            telephoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            telephoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            telephoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            telephoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            telephoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            telephoneTextField.topAnchor.constraint(equalTo: telephoneLabel.bottomAnchor, constant: 5),
            telephoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailLabel.topAnchor.constraint(equalTo: telephoneTextField.bottomAnchor, constant: 10),
            
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            addressTextField.heightAnchor.constraint(equalToConstant: 50)
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
        let telephoneContactPerson = telephoneTextField.text ?? ""
        let emailContactPerson = emailTextField.text ?? ""
        let addressContactPerson = addressTextField.text ?? ""
        
        if telephoneContactPerson.isEmpty && emailContactPerson.isEmpty && addressContactPerson.isEmpty {
            telephoneTextField.shake()
            emailTextField.shake()
            addressTextField.shake()
        //} else if !telephoneContactPerson.isEmpty && telephoneContactPerson.count != 11 {
        } else if !telephoneContactPerson.isEmpty && telephoneContactPerson.count != 18 {
            telephoneTextField.shake()
        } else if !emailContactPerson.isEmpty && !validEmail(email: emailContactPerson) {
            emailTextField.shake()
        } else if !addressContactPerson.isEmpty && addressContactPerson.count < 5 {
            addressTextField.shake()
        } else {
            var jsonArray = [[String: String]]()
            
            if !telephoneContactPerson.isEmpty {
                let getKind = "Телефон"
                let getPresentation = telephoneContactPerson
                let array = [getKind : getPresentation, "owner_uuid" : selectedUUID ?? ""]
                jsonArray.append(array)
            }
            if !emailContactPerson.isEmpty {
                let getKind = "Электронная почта"
                let getPresentation = emailContactPerson
                let array = [getKind : getPresentation, "owner_uuid" : selectedUUID ?? ""]
                jsonArray.append(array)
            }
            if !addressContactPerson.isEmpty {
                let getKind = "Адрес"
                let getPresentation = addressContactPerson
                let array = [getKind : getPresentation, "owner_uuid" : selectedUUID ?? ""]
                jsonArray.append(array)
            }
            
            if jsonArray.count > 0 {
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
            }
            
   /*         // создать запрос POST
            let url = URL(string: "http://httpbin.org/post")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // вставить данные JSON в запрос
            request.httpBody = jsonData

            // выполнить запрос и обработать ответ
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }

            task.resume()       */
            
            let alert = UIAlertController(title: "Контактная информация сохранена", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func closeButtonClicked() {
        let alert = UIAlertController(title: "Все не сохраненные данные будут потеряны, хотите закрыть?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        telephoneTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height // UIScreen.main.bounds.height
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let heightTabBar = (self.tabBarController?.tabBar.frame.height ?? 49.0) + 10
            let emptySpaceHeight = view.frame.size.height - emailTextField.frame.origin.y - emailTextField.frame.size.height - heightTabBar
            let difference = keyboardHeight - emptySpaceHeight
            if emptySpaceHeight <= keyboardHeight {
                //let contentOffset: CGPoint = notification.name == UIResponder.keyboardWillHideNotification ? .zero : CGPoint(x: 0, y:  difference)
                self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
            }
        }
    }
    
    @objc func kbwillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension AddContactInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = formatNumberPhone(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}

