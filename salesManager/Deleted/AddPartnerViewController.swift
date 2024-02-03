//
//  AddPartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.01.2024.
//

import UIKit

final class AddPartnerViewController: UIViewController {
    
    private let maxNumberCount = 11
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    let businessRegionArray = ["1 направление", "2 направление", "Интернет-магазин", "Маркетплейсы", "Металлолом и прочие отходы", "Наша Компания", "Перевозчики-Москва", "Перевозчики-Уфа", "Прочая реализация", "Розница Уфа", "РРП", "Тара", "Тендер", "Фантош", "Федералы 2", "Федеральные сети", "Экспорт"]
    
    let accessGroupArray = ["Группа доступа по умолчанию", "Общие клиенты (Екатеренбург - Москва)", "Общие клиенты (Екатеренбург - Уфа)", "Общие клиенты (Краснодар - Москва)", "Общие клиенты (Кранснодар - Уфа)", "Общие клиенты (Москва - Казань)", "Общие клиенты (Москва - Санкт-Петербург)", "Общие клиенты (Новосибирск - Москва)", "Общие клиенты (Новосибирск - Санкт-Петербург)", "Общие клиенты (Новосибирск - Уфа)", "Общие клиенты (Санкт-Петербург - Уфа)", "Общие клиенты (Краснодар - Санкт-Петербург)", "Общие партнеры", "Поставщики", "РРП Екатеренбург", "РРП Казань", "РРП Краснодар", "РРП Моква", "РРП Новосибирск", "РРП Санкт-Петербург", "Экспорт"]
    
    let typeOfRelationshipArray = ["Клиент", "Поставщик", "Конкурент", "Прочие отношения"]
    
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
    
    private lazy var businessRegionPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var accessGroupPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var typeOfRelationshipPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Наименование:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accessGroupLabel: UILabel = {
        let label = UILabel()
        label.text = "Группа доступа:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeOfRelationshipLabel: UILabel = {
        let label = UILabel()
        label.text = "Тип отношений:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var businessRegionLabel: UILabel = {
        let label = UILabel()
        label.text = "Бизнес-регион:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес:"
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
    
    private lazy var accessGroupTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите группу доступа"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var typeOfRelationshipTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите тип отношений"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var businessRegionTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Выберите бизнес-регион"
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(accessGroupLabel)
        contentView.addSubview(typeOfRelationshipLabel)
        contentView.addSubview(businessRegionLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(telephoneLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(accessGroupTextField)
        contentView.addSubview(typeOfRelationshipTextField)
        contentView.addSubview(businessRegionTextField)
        contentView.addSubview(addressTextField)
        contentView.addSubview(telephoneTextField)
        contentView.addSubview(emailTextField)
                        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(kbwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil) 
        
        businessRegionTextField.inputView = businessRegionPickerView
        accessGroupTextField.inputView = accessGroupPickerView
        typeOfRelationshipTextField.inputView = typeOfRelationshipPickerView
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новый партнер"
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
           // contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
           // contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            accessGroupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            accessGroupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accessGroupLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            
            accessGroupTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            accessGroupTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accessGroupTextField.topAnchor.constraint(equalTo: accessGroupLabel.bottomAnchor, constant: 5),
            accessGroupTextField.heightAnchor.constraint(equalToConstant: 50),
            
            typeOfRelationshipLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeOfRelationshipLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typeOfRelationshipLabel.topAnchor.constraint(equalTo: accessGroupTextField.bottomAnchor, constant: 10),
            
            typeOfRelationshipTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeOfRelationshipTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typeOfRelationshipTextField.topAnchor.constraint(equalTo: typeOfRelationshipLabel.bottomAnchor, constant: 5),
            typeOfRelationshipTextField.heightAnchor.constraint(equalToConstant: 50),
            
            businessRegionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            businessRegionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            businessRegionLabel.topAnchor.constraint(equalTo: typeOfRelationshipTextField.bottomAnchor, constant: 10),
            
            businessRegionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            businessRegionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            businessRegionTextField.topAnchor.constraint(equalTo: businessRegionLabel.bottomAnchor, constant: 5),
            businessRegionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressLabel.topAnchor.constraint(equalTo: businessRegionTextField.bottomAnchor, constant: 10),
            
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            telephoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            telephoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            telephoneLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10),
            
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
            //emailTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
        let namePartner = nameTextField.text ?? ""
        let accessGroupPartner = accessGroupTextField.text ?? ""
        let typeOfRelationshipPartner = typeOfRelationshipTextField.text ?? ""
        let businessRegionPartner = businessRegionTextField.text ?? ""
        let addressPartner = addressTextField.text ?? ""
        let telephonePartner = telephoneTextField.text ?? ""
        let emailPartner = emailTextField.text ?? ""
        
        if namePartner.isEmpty {
            nameTextField.shake()
        } else if accessGroupPartner.isEmpty {
            accessGroupTextField.shake()
        } else if typeOfRelationshipPartner.isEmpty {
            typeOfRelationshipTextField.shake()
        } else if telephonePartner.isEmpty && emailPartner.isEmpty {
            telephoneTextField.shake()
            emailTextField.shake()
        } else if !telephonePartner.isEmpty && telephonePartner.count != 11 {
            telephoneTextField.shake()
        } else if !emailPartner.isEmpty && !validEmail(email: emailPartner) {
            emailTextField.shake()
        } else {
            let alert = UIAlertController(title: "Новый партнер сохранен", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                //let partnersViewController = PartnersViewController()
                //self.navigationController?.pushViewController(partnersViewController, animated: true)
            }))
            present(alert, animated: true, completion: nil)
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
        accessGroupTextField.resignFirstResponder()
        typeOfRelationshipTextField.resignFirstResponder()
        businessRegionTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        telephoneTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height // UIScreen.main.bounds.height
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let heightTabBar = (self.tabBarController?.tabBar.frame.height ?? 49.0) + 10
            let emptySpaceHeight = view.frame.size.height - emailTextField.frame.origin.y - emailTextField.frame.size.height - heightTabBar
            //let difference = keyboardHeight - ((screenHeight / 2) - 165)
            //if ((screenHeight / 2) - 165) <= keyboardHeight {
            let difference = keyboardHeight - emptySpaceHeight
            if emptySpaceHeight <= keyboardHeight {
                //let contentOffset: CGPoint = notification.name == UIResponder.keyboardWillHideNotification ? .zero : CGPoint(x: 0, y:  difference)
                self.scrollView.contentOffset = CGPoint(x: 0, y: difference)
                //self.scrollView.setContentOffset(contentOffset, animated: true)
            }
        }
    }
    
    @objc func kbwillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension AddPartnerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = formatNumberPhone(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
    }
}

extension AddPartnerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == businessRegionPickerView {
            return businessRegionArray.count
        } else if pickerView == accessGroupPickerView {
            return accessGroupArray.count
        } else if pickerView == typeOfRelationshipPickerView {
            return typeOfRelationshipArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == businessRegionPickerView {
            return businessRegionArray[row]
        } else if pickerView == accessGroupPickerView {
            return accessGroupArray[row]
        } else if pickerView == typeOfRelationshipPickerView {
            return typeOfRelationshipArray[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == businessRegionPickerView {
            businessRegionTextField.text = businessRegionArray[row]
            businessRegionTextField.resignFirstResponder()
        } else if pickerView == accessGroupPickerView {
            accessGroupTextField.text = accessGroupArray[row]
            accessGroupTextField.resignFirstResponder()
        } else if pickerView == typeOfRelationshipPickerView {
            typeOfRelationshipTextField.text = typeOfRelationshipArray[row]
            typeOfRelationshipTextField.resignFirstResponder()
        } else {
            //activeTextField.text = activeArray[row]
            //activeTextField.resignFirstResponder()
        }
    }
}

