//
//  File.swift
//  salesManager
//
//  Created by Роман Кокорев on 05.12.2023.
//

import UIKit

final class LogInViewContoller: UIViewController{
    
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
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.alpha = 0.3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginPasswordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray6
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .systemGray
        textField.placeholder = "Email или телефон"
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = true
        textField.textColor = .systemGray
        textField.placeholder = "Пароль"
        textField.layer.borderWidth = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.signUpButtonButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(self.registrationButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var invalidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 8
        label.contentMode = .scaleToFill
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var validationData = ValidationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupContraint()
    }

    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = .systemGray
    }
        
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginPasswordStackView)
        contentView.addSubview(signUpButton)
        contentView.addSubview(registrationButton)
        contentView.addSubview(invalidLabel)
        loginPasswordStackView.addArrangedSubview(loginTextField)
        loginPasswordStackView.addArrangedSubview(passwordTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupContraint() {
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            loginPasswordStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loginPasswordStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginPasswordStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginPasswordStackView.heightAnchor.constraint(equalToConstant: 100),
                        
            logoImageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: loginPasswordStackView.topAnchor, constant: -25),
            logoImageView.widthAnchor.constraint(equalToConstant: screenWidth - 100),
            
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.topAnchor.constraint(equalTo: loginPasswordStackView.bottomAnchor, constant: 20),
            
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            
            invalidLabel.topAnchor.constraint(equalTo: registrationButton.bottomAnchor),
            invalidLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            invalidLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func validEmail(email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validEmail = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return validEmail.evaluate(with: email)
    }

    private func validPassword(password : String) -> Bool {
        let passwordReg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordTesting = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordTesting.evaluate(with: password) && password.count > 6
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func signUpButtonButtonClicked() {
        guard let email = loginTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        let enteredEmail = validEmail(email: email)
        let enteredPassword = validPassword(password: password)
        
        if email.isEmpty && password.isEmpty {
            loginTextField.shake()
            passwordTextField.shake()
        } else if email.isEmpty {
            loginTextField.shake()
        } else if password.isEmpty {
            passwordTextField.shake()
        } else {
            if !enteredPassword && !enteredEmail {
                invalidLabel.text = validationData.invalidEmailAndPassword
                invalidLabel.isHidden = false
                passwordTextField.shake()
                loginTextField.shake()
            } else if !enteredPassword {
                invalidLabel.text = validationData.invalidPassword
                invalidLabel.isHidden = false
                passwordTextField.shake()
            } else if !enteredEmail {
                invalidLabel.text = validationData.invalidEmail
                invalidLabel.isHidden = false
                loginTextField.shake()
            } else {
                if (enteredEmail && enteredPassword) && (loginTextField.text != validationData.defaultLogin || passwordTextField.text != validationData.defaultPassword) {
                    let alert = UIAlertController(title: "Неверный логин или пароль", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                } else {
                    navigationController?.pushViewController(ViewController(), animated: true)
                    invalidLabel.isHidden = true
                }
            }
        }
        
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func registrationButtonClicked() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let screenHeight = UIScreen.main.bounds.height
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let difference = keyboardHeight - ((screenHeight / 2) - 230)
            if ((screenHeight / 2) - 230) <= keyboardHeight {
                let contentOffset: CGPoint = notification.name == UIResponder.keyboardWillHideNotification ? .zero : CGPoint(x: 0, y:  difference)
                self.scrollView.setContentOffset(contentOffset, animated: true)
            }
        }
    }
    
}


