//
//  UserView.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 9.04.2022.
//

import Foundation

import SnapKit

protocol UserViewDelegate: AnyObject {
    func changeProfile(user: User)
}

class UserView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        makeConstraints()
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var user: User? {
        didSet {
            populate()
        }
    }
    
    var changeProfileButtonOutlet: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
        return button
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    weak var delegate: UserViewDelegate?
    
    func applyUI() {
        changeProfileButtonOutlet.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        changeProfileButtonOutlet.setTitleColor(.black, for: .normal)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
    }
    
    func populate() {
        changeProfileButtonOutlet.setTitle(user?.userName ?? "", for: .normal)
        profileImageView.image = UIImage(named: user?.avatar ?? "")

    }
    
    @objc func changeProfile() {
        guard let user = user else {
            return
        }

        delegate?.changeProfile(user: user)
    }
    
    func makeConstraints() {
        
        addSubview(verticalStackView)
        verticalStackView.addSubview(profileImageView)
        verticalStackView.addSubview(changeProfileButtonOutlet)
        
        verticalStackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        changeProfileButtonOutlet.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalTo(self).offset(24)
            make.centerY.equalTo(self)
        }
    }
    
}
