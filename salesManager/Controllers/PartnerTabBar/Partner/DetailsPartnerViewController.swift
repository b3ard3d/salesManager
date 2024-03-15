//
//  DetailsPartnerViewController.swift
//  salesManager
//
//  Created by Роман Кокорев on 10.01.2024.
//

import UIKit
import EventKit
import EventKitUI

final class DetailsPartnerViewController: UIViewController {
    
    var selectedName, selectedUUID: String?
    var contactDetailsPartners = [ContactDetailsPartner]()
    var contactPersonPartners = [ContactPersonPartner]()
    let dataManager = DataManager()
    let openApplication = OpenApplication()
    let eventStore = EKEventStore()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        if let text = selectedName {
            label.text = "Наименование: " + text
        } else {
            label.text = "Наименование: "
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
    
    private lazy var tableViewContactPerson: UITableView = {
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
        setupNavigationBar()
        setupTabBar()
        //setupConstraint()
        
        dataManager.getAllContactPersonPartners { [self] contactPersonPartner in
            self.contactPersonPartners = contactPersonPartner.filter{ $0.owner_uuid == self.selectedUUID}
            self.contactPersonPartners.sort { $0.name < $1.name }
            self.tableViewContactPerson.reloadData()
        }
        
        dataManager.getContactDetailsPartnersByOwnerUUID(owner_uuid: selectedUUID ?? "", complitionHander: { contactDetailsPartner in
            self.contactDetailsPartners = contactDetailsPartner
            self.contactDetailsPartners.sort { $0.kind < $1.kind }
            self.tableViewContact.reloadData()
            self.setupConstraint()
        })
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(tableViewContact)
        view.addSubview(tableViewContactPerson)
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        
        let addNewActionButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,  target: self, action: #selector(addNewActionClicked))
        navigationItem.rightBarButtonItems = [addNewActionButton]
    }
    
    private func setupTabBar() {
        //tabBarController?.tabBar.isHidden = true
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            tableViewContact.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContact.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewContact.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            //tableViewContact.heightAnchor.constraint(equalToConstant: 200),
            tableViewContact.heightAnchor.constraint(equalToConstant: tableViewContact.contentSize.height + 5),
            //tableViewContact.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableViewContactPerson.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContactPerson.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewContactPerson.topAnchor.constraint(equalTo: tableViewContact.bottomAnchor),
            tableViewContactPerson.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        print(tableViewContact.contentSize.height)
    }
    
    private func requestAccessToReminders() {
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                print("Доступ к напоминаниям разрешен")
            } else {
                print("Доступ к напоминаниям запрещен")
            }
        }
    }
    
    func createReminder() {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore // используем наш eventStore, который имеет доступ к напоминаниям
        eventEditVC.event = EKEvent(eventStore: eventStore) // создаем новое напоминание
        eventEditVC.event?.calendar = .init(for: .reminder, eventStore: eventStore)
        eventEditVC.editViewDelegate = self // устанавливаем себя делегатом
        present(eventEditVC, animated: true, completion: nil)
    }
    
    @objc func addNewActionClicked() {
        let alert = UIAlertController(title: "Создать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Напоминание", style: .default, handler: { action in
            self.createReminder()
        }))
        alert.addAction(UIAlertAction(title: "Встреча", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Заказ", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Сделка", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Запланировать взаимодействие", style: .default, handler: { action in

        }))
        alert.addAction(UIAlertAction(title: "Чек лист", style: .default, handler: { action in

        }))
     /*   alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { action in
            var numberArray = [String]()
            for contactDetailsPartner in self.contactDetailsPartners {
                if contactDetailsPartner.kind == "Телефон клиента" || contactDetailsPartner.kind == "Телефон" {
                    numberArray.append(contactDetailsPartner.presentation)
                }
            }
            for number in numberArray {
                self.openApplication.openWhatsAppChat(contactNumber: number)
            }
        })) */
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addContactPersonButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить новое контактное лицо?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addContactPersonViewController = AddContactPersonPartnerViewController()
            self.navigationController?.pushViewController(addContactPersonViewController, animated: true)
            //self.present(addPartnerViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addContactInfoButtonClicked() {
        let alert = UIAlertController(title: "Хотите добавить новую контактную информацию?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            let addContactInfoViewController = AddContactInfoViewController()
            addContactInfoViewController.selectedName = self.selectedName
            addContactInfoViewController.selectedUUID = self.selectedUUID
            self.navigationController?.pushViewController(addContactInfoViewController, animated: true)
            //self.present(addPartnerViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailsPartnerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewContact {
            return contactDetailsPartners.count
        } else if tableView == tableViewContactPerson {
            return contactPersonPartners.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView == tableViewContact {
            let contactDetailsPartner = contactDetailsPartners[indexPath.row]
            cell.textLabel?.text = (contactDetailsPartner.kind ?? "") + ": " + (contactDetailsPartner.presentation ?? "")
        } else if tableView == tableViewContactPerson {
            let contactPersonPartner = contactPersonPartners[indexPath.row]
            cell.textLabel?.text = contactPersonPartner.name
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
                    
        } else if tableView == tableViewContactPerson {
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            label.text = "Контактные лица:"
                    
            let addContactPersonButton = UIButton.init(frame: CGRect(x: (headerView.frame.width / 2) - 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            addContactPersonButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addContactPersonButton.addTarget(self, action: #selector(addContactPersonButtonClicked), for: .touchUpInside)
                    
            headerView.addSubview(label)
            headerView.addSubview(addContactPersonButton)
        } else {
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewContactPerson {
            let viewController = DetailsContactPersonPartnerViewController()
            viewController.selectedFullName = contactPersonPartners[indexPath.row].name
            viewController.selectedUUID = contactPersonPartners[indexPath.row].uuid
            
            navigationController?.pushViewController(viewController, animated: true)
        } else if tableView == tableViewContact {
            let viewController = ContactInfoViewController()
            viewController.selectedKind = contactDetailsPartners[indexPath.row].kind
            viewController.selectedPresentation = contactDetailsPartners[indexPath.row].presentation
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension DetailsPartnerViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        // Обрабатываем действие
        switch action {
        case .canceled:
            print("Пользователь отменил создание напоминания")
        case .saved:
            print("Пользователь сохранил напоминание")
            // Сохраняем напоминание в хранилище
            do {
                try eventStore.save(controller.event as! EKReminder, commit: true)
            } catch {
                print("Ошибка при сохранении напоминания: \(error)")
            }
        case .deleted:
            print("Пользователь удалил напоминание")
        default:
            break
        }
    }
}
