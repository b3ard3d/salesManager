//
//  PartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit

class PartnersViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    //var searchResponse: SearchResponse? = nil
    //let networkManager = NetworkManager()
    let dataManager = DataManager()
    let coreDataManager = CoreDataManager.shared
    var partners = [Partner]()
        
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
        setupConstraint()
        setupNavigationBar()
        setupTabBar()
        
        if Reachability.isConnectedToNetwork() == true {
             print("Internet connection OK")
            
          } else {
             print("Internet connection FAILED")
         }
        
        dataManager.getAllPartners { partner in
            self.partners = partner
            self.partners.sort { $0.name < $1.name }
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
        
        let userAuthorization = defaults.bool(forKey: "userAuthorization")
        let userLogin = defaults.string(forKey: "userLogin") ?? ""
        if userAuthorization {
            let exitButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitButtonClicked))
            navigationItem.leftBarButtonItems = [exitButton]
            navigationItem.title = userLogin
        }
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
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
            self.coreDataManager.deleteAllAndCreateNewDB()
            
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
    
    @objc func addNewActionClicked() {
        let alert = UIAlertController(title: "Создать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Встреча", style: .default, handler: { action in
            let addColdClientViewController = AddColdClientViewController()
            self.navigationController?.pushViewController(addColdClientViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
/*    @objc func addPartnerButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить нового партнера?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            //обработка действий
            let addPartnerViewController = AddPartnerViewController()
            self.navigationController?.pushViewController(addPartnerViewController, animated: true)
            //self.present(addPartnerViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }   */

}

extension PartnersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let partner = partners[indexPath.row]
        cell.textLabel?.text = partner.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailsPartnerViewController()
        viewController.selectedName = partners[indexPath.row].name
        viewController.selectedUUID = partners[indexPath.row].uuid
        navigationController?.pushViewController(viewController, animated: true)
    }

}

