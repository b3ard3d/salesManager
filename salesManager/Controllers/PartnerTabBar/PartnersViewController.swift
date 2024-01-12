//
//  PartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit

class PartnerViewController1: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ПАРТНЕРЫ"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupContraint()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
    }
    
    private func setupNavigationBar() {
        //navigationItem.backButtonTitle = "Назад"
        //navigationController?.navigationBar.tintColor = .systemGray
    }
    
    func setupContraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            //artworkImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    @objc func tapKeyboardOff(_ sender: Any) {
        //loginTextField.resignFirstResponder()
        //passwordTextField.resignFirstResponder()
    }
}

