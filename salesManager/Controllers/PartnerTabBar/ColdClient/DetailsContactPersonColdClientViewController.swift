//
//  DetailsContactPersonColdClientViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.01.2024.
//

import UIKit

final class DetailsContactPersonColdClientViewController: UIViewController {
    
    var selectedFullName, selectedUUID: String?
    var contactDetailsContactPersonColdClients = [ContactDetailsContactPersonColdClient]()
    let dataManager = DataManager()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedFullName {
            label.text = "ФИО: " + text
        } else {
            label.text = "ФИО: "
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableViewContact: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTabBar()
        setupConstraint()
        
        dataManager.getContactDetailsContactPersonColdClientsByOwnerUUID(owner_uuid: selectedUUID ?? "", complitionHander: { contactDetailsContactPersonColdClient in
            self.contactDetailsContactPersonColdClients = contactDetailsContactPersonColdClient
            self.contactDetailsContactPersonColdClients.sort { $0.kind < $1.kind }
            self.tableViewContact.reloadData()
            //self.setupConstraint()
        })
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(fullNameLabel)
        view.addSubview(tableViewContact)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            tableViewContact.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContact.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewContact.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            tableViewContact.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func addContactInfoButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить новую контактную информацию?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addContactInfoViewController = AddContactInfoViewController()
            addContactInfoViewController.selectedName = self.selectedFullName
            addContactInfoViewController.selectedUUID = self.selectedUUID
            self.navigationController?.pushViewController(addContactInfoViewController, animated: true)
            //self.present(addPartnerViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailsContactPersonColdClientViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewContact {
            return contactDetailsContactPersonColdClients.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView == tableViewContact {
            let contactDetailsContactPersonColdClient = contactDetailsContactPersonColdClients[indexPath.row]
            cell.textLabel?.text = (contactDetailsContactPersonColdClient.kind ?? "") + ": " + (contactDetailsContactPersonColdClient.presentation ?? "")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .systemBackground
        
        if tableView == tableViewContact {
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            label.text = "Контактная информация:"
            
            let addContactInfoButton = UIButton.init(frame: CGRect(x: (headerView.frame.width / 2) - 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            addContactInfoButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addContactInfoButton.addTarget(self, action: #selector(addContactInfoButtonClicked), for: .touchUpInside)
                    
            headerView.addSubview(label)
            headerView.addSubview(addContactInfoButton)
                    
        } else {
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewContact {
            let viewController = ContactInfoViewController()
            viewController.selectedKind = contactDetailsContactPersonColdClients[indexPath.row].kind
            viewController.selectedPresentation = contactDetailsContactPersonColdClients[indexPath.row].presentation
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
