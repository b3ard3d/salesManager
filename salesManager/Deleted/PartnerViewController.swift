//
//  PartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 05.12.2023.
//

import UIKit

final class PartnerViewController: UIViewController {
    
    var selectedArtistName, selectedTrackName, selectedCollectionName, selectedArtworkUrl60: String?
    
    private lazy var artworkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedArtistName {
            label.text = "Artist: " + text
        }
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedTrackName {
            label.text = "Track: " + text
        }
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedCollectionName {
            label.text = "Collection: " + text
        }
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTabBar()
        setupConstraint()
        
        if let text = self.selectedArtworkUrl60 {
            self.setImageFromStringrURL(stringUrl: text)
        }
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(artworkImage)
        view.addSubview(artistNameLabel)
        view.addSubview(trackNameLabel)
        view.addSubview(collectionNameLabel)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            artworkImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            artworkImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            artistNameLabel.topAnchor.constraint(equalTo: artworkImage.bottomAnchor, constant: 10),
            
            trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),

            collectionNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func setImageFromStringrURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let imageData = data else { return }
          DispatchQueue.main.async {
              self.artworkImage.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }


}

