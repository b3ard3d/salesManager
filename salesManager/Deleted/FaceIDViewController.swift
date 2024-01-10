//
//  FaceIDViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 20.12.2023.
//

import UIKit
import LocalAuthentication

final class FaceIDViewController: UIViewController{
    let context = LAContext()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.alpha = 0.3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView() 
        setupContraint()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate to proceed.") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        // Что-то сделать
                        print("OK")
                        self.navigationController?.pushViewController(MainViewController(), animated: true)
                        //self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                    self.navigationController?.pushViewController(MainTabBarController(), animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate to proceed.") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        // Что-то сделать
                        print("OK")
                        self.navigationController?.pushViewController(MainViewController(), animated: true)
                        //self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                    self.navigationController?.pushViewController(MainTabBarController(), animated: true)
                }
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
    }
    
    func setupContraint() {
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: screenWidth - 100)        ])
    }
}


