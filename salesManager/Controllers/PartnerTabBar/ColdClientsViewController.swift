//
//  ColdClientsViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit

final class ColdClientsViewController1: UIViewController {
    
    let defaults = UserDefaults.standard
    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
        
    let networkManager = NetworkManager()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContraint()
        setupNavigationBar()
        setupTabBar()
        
        let userAuthorization = defaults.bool(forKey: "userAuthorization")
        let userLogin = defaults.string(forKey: "userLogin")
        let userPassword = defaults.string(forKey: "userPassword")
        if userAuthorization {
            let exitButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitButtonClicked))
            navigationItem.rightBarButtonItems = [exitButton]
            navigationItem.title = userLogin
        }
        
        networkManager.getTrack { searchResponse in
            guard let searchResponse = searchResponse else { return }
            self.searchResponse = searchResponse
            self.tableView.reloadData()
        }
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        navigationItem.hidesBackButton = true
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupContraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func exitButtonClicked() {
        let alert = UIAlertController(title: "Вы уверены что хотите выйти", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.defaults.removeObject(forKey: "userLogin")
            self.defaults.removeObject(forKey: "userPassword")
            self.defaults.removeObject(forKey: "userAuthorization")
            self.defaults.removeObject(forKey: "useFaceID")
            //self.navigationController?.pushViewController(LogInViewContoller(), animated: true)
            
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            guard let rootViewController = window.rootViewController else {
                return
            }
            let viewController = MainTabBarController()
            viewController.view.frame = rootViewController.view.frame
            viewController.view.layoutIfNeeded()

            UIView.transition(with: window, duration: 0.6, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = viewController
            }, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension ColdClientsViewController1: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("artistName: ", searchResponse?.results[indexPath.row].artistName ?? "")
        //print("trackName: ", searchResponse?.results[indexPath.row].trackName ?? "")
        //print("collectionName: ", searchResponse?.results[indexPath.row].collectionName ?? "")
        //print("artworkUrl60: ", searchResponse?.results[indexPath.row].artworkUrl60 ?? "")
        
        let viewController = PartnerViewController()
        viewController.selectedArtistName = searchResponse?.results[indexPath.row].artistName ?? ""
        viewController.selectedTrackName = searchResponse?.results[indexPath.row].trackName ?? ""
        viewController.selectedCollectionName = searchResponse?.results[indexPath.row].collectionName ?? ""
        viewController.selectedArtworkUrl60 = searchResponse?.results[indexPath.row].artworkUrl60 ?? ""
        
  /*      viewController.selectedArtistName = tracks[indexPath.row].artistName
        viewController.selectedTrackName = tracks[indexPath.row].trackName
        viewController.selectedCollectionName = tracks[indexPath.row].collectionName
        viewController.selectedArtworkUrl60 = tracks[indexPath.row].artworkUrl60    */
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
