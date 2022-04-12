//
//  ProfileSelectionController.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 9.04.2022.
//

import Foundation
import UIKit

protocol ProfileSelectionControllerDelegate: AnyObject {
    func reloadMainScreen()
}

class ProfileSelectionController: UIViewController {
    
    var viewModel: ProfileSelectionViewModel?
    
    weak var delegate: ProfileSelectionControllerDelegate?
    
    init(viewModel: ProfileSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        topView.addSubview(topLine)
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(6)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
       
        topView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(topLine).offset(20)
        }
        
        viewModel?.users.forEach({ user in
            
            let userView = UserView()
            
            userView.user = user
            userView.delegate = self
            stackView.addArrangedSubview(userView)
            
            userView.snp.makeConstraints { make in
                make.trailing.leading.equalToSuperview()
            }
            
        })
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        topView.addGestureRecognizer(panGesture)
    }
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.y >= 0 else { return }
        
        view.frame.origin = CGPoint(x: 0, y: (self.pointOrigin?.y ?? 0) + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

extension ProfileSelectionController: UserViewDelegate {
    
    func changeProfile(user: User) {
        
        let savedUser = try? CoreDataManager.shared.mainContext.fetch(SavedUser.fetchRequest()).first
        
        savedUser?.user = user
        CoreDataManager.shared.saveContext()
        
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.reloadMainScreen()
        }
        
    }
    
}
