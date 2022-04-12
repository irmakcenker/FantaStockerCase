//
//  ProfileDrawerView.swift
//  socialApp
//
//  Created by cenker.irmak on 8.04.2022.
//

import UIKit
import SnapKit

protocol ProfileDrawerViewDelegate: AnyObject {
    func changeProfile()
}

class ProfileDrawerView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        makeConstraints()
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var changeProfileButtonOutlet: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 8, right: 8)
        return button
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.layer.masksToBounds = true
    }
    
    weak var delegate: ProfileDrawerViewDelegate?
    
    func applyUI() {
        self.backgroundColor = .white
        changeProfileButtonOutlet.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        changeProfileButtonOutlet.setTitleColor(.black, for: .normal)
    }
    
    func populate(viewModel: User) {
        changeProfileButtonOutlet.setTitle(viewModel.userName, for: .normal)
        profileImageView.image = UIImage(named: viewModel.avatar ?? "")
        changeProfileButtonOutlet.setImage(UIImage(named: "down_arrow"), for: .normal)
    }
    
    @objc func changeProfile() {
        delegate?.changeProfile()
    }
    
    func makeConstraints() {
    
        self.addSubview(horizontalStackView)
        horizontalStackView.addSubview(profileImageView)
        horizontalStackView.addSubview(changeProfileButtonOutlet)
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        changeProfileButtonOutlet.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalTo(self).offset(24)
            make.centerY.equalTo(self)
        }
    }

}
