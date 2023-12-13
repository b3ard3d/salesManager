//
//  RegistrationViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 05.12.2023.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        //tableView.backgroundColor = .systemGray6
        //tableView.layer.borderColor = UIColor.lightGray.cgColor
        //tableView.layer.borderWidth = 0.5
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContraint()
        
        let urlString = "https://itunes.apple.com/search?term=50+cent&limit=5"
        
        networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponse) in
            guard let searchResponse = searchResponse else { return }
            self.searchResponse = searchResponse
            self.tableView.reloadData()
        }
        
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    func setupContraint() {        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension RegistrationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        print("track?.artworkUrl60:", track?.artworkUrl60)
        cell.textLabel?.text = track?.trackName
        return cell
    }
    
    
}
