//
//  RegistrationViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 05.12.2023.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .systemBackground
    }

}
