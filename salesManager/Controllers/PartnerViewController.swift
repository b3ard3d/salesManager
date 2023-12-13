//
//  ViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 05.12.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"
        let urlString = "https://itunes.apple.com/search?term=jack+jones&limit=5"
        
            networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponse) in
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
            }
        
        let track = searchResponse?.results.count
        
        print("track:", track)
        
    }

    func setupView() {
        view.backgroundColor = .systemBackground
    }

}

