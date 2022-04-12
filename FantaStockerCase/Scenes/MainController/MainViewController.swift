//
//  MainViewController.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 8.04.2022.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    var postButton: FSButton = {
        let button = FSButton()
        button.backgroundColor = .twitterDark
        button.cornerRadius = 45
        button.borderWidth = 1
        button.borderColor = .white
        button.shadowColor = .twitterDark
        button.shadowRadius = 3
        button.shadowOpacity = 0.6
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.shadowOffset = CGSize(width: 1, height: 4)
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var viewModel: MainViewModelProtocol
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerCells() {
        tableView.registerCell(type: PostView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerCells()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        viewModel.loadUsers { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(postButton)
        
        postButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(90)
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, ProfileDrawerViewDelegate {
    
    func changeProfile() {
        filterButtonTapped()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: ProfileDrawerView = ProfileDrawerView()
        guard let user = CoreDataManager.shared.getSavedUser() else { return UITableViewCell() }
        cell.populate(viewModel: user)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PostView = tableView.dequeue(for: indexPath)
        guard let postObjects = viewModel.posts else { return UITableViewCell() }
        cell.populate(viewModel: postObjects[indexPath.row])
        return cell
        
    }
    
    @objc func filterButtonTapped() {
        let viewModel = ProfileSelectionViewModel(users: viewModel.users)
        let profileSelectionController = ProfileSelectionController(viewModel: viewModel)
        profileSelectionController.modalPresentationStyle = .custom
        profileSelectionController.transitioningDelegate = self
        profileSelectionController.delegate = self
        
        self.present(profileSelectionController, animated: true, completion: nil)
    }
    
    @objc func postButtonTapped() {
        let viewModel = CreatePostViewModel()
        let controller = CreatePostViewController(viewModel: viewModel)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}

extension MainViewController: UIViewControllerTransitioningDelegate, ProfileSelectionControllerDelegate, CreatePostViewControllerDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ProfilePresantationController(presentedViewController: presented, presenting: presenting)
    }
    
    func reloadMainScreen() {
        tableView.reloadData()
    }
    
    func dismissCreateViewController() {
        viewModel.getPosts { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
