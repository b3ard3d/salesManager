//
//  ChistiyViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 18.12.2023.
//

import UIKit

final class ChistiyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupContraint()
    }
    
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardOff(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavigationBar() {
        //navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = .systemGray
    }
    
    func setupContraint() {
        NSLayoutConstraint.activate([
            //artworkImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        //loginTextField.resignFirstResponder()
        //passwordTextField.resignFirstResponder()
    }
    
}

