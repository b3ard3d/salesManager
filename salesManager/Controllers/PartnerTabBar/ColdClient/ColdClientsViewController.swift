//
//  ColdClientsViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit

final class ColdClientsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let dataManager = DataManager()
    let coreDataManager = CoreDataManager.shared
    var coldClients = [ColdClient]()
    let openApplication = OpenApplication()
        
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
        
        dataManager.getAllColdClients { coldClient in
            self.coldClients = coldClient
            self.coldClients.sort { $0.name < $1.name }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.getAllColdClients { coldClient in
            self.coldClients = coldClient
            self.coldClients.sort { $0.name < $1.name }
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
        let userLogin = defaults.string(forKey: "userLogin")
        if userAuthorization {
            let exitButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(exitButtonClicked))
            let addNewColdClientButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done,  target: self, action: #selector(addColdClientButtonClicked))
            navigationItem.rightBarButtonItems = [addNewColdClientButton]
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
    
    @objc func addColdClientButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить нового холодного клиента?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addColdClientViewController = AddColdClientViewController()
            self.navigationController?.pushViewController(addColdClientViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
/*    @objc func addNewActionClicked() {
        let alert = UIAlertController(title: "Создать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Холодный клиент", style: .default, handler: { action in
            let addColdClientViewController = AddColdClientViewController()
            self.navigationController?.pushViewController(addColdClientViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Напоминание", style: .default, handler: { action in
            self.openApplication.createReminder()
        }))
        alert.addAction(UIAlertAction(title: "Встреча", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Заказ", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Сделка", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Электронное письмо", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Запланировать взаимодействие", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Чек лист", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { action in
            self.openApplication.openWhatsAppChat(contactNumber: "+79173595444")
        }))
        
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }   */
}

extension ColdClientsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coldClients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let coldClient = coldClients[indexPath.row]
        cell.textLabel?.text = coldClient.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailsColdClientViewController()
        viewController.selectedName = coldClients[indexPath.row].name
        viewController.selectedUUID = coldClients[indexPath.row].uuid
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
