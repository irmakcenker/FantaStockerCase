//
//  PostView.swift
//  socialApp
//
//  Created by cenker.irmak on 8.04.2022.
//

import UIKit
import SnapKit

class PostView: UITableViewCell {
    
    var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    var userProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    var userProfileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        return image
    }()
    
    var userNameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var contentImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    var contentLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        containerStackView.addArrangedSubview(userProfileStackView)
        userProfileStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        userProfileStackView.addArrangedSubview(userProfileImageView)
        userProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        userProfileStackView.addArrangedSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageView.snp.centerY)
        }
        
        containerStackView.addArrangedSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.lastBaseline).offset(8)
            make.leading.trailing.equalToSuperview().offset(24)
        }
        
        containerStackView.addArrangedSubview(contentImageView)
        contentImageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.lastBaseline).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(100)
            
        }
    }
    
    func populate(viewModel: Post) {
        
        contentLabel.text = viewModel.text
        userNameLabel.text = viewModel.owner?.userName
        
        let userProfileImage = UIImage(named: viewModel.owner?.avatar ?? "")
        userProfileImageView.image = userProfileImage
        
        if let image = viewModel.image {
            contentImageView.image = UIImage(data: image)
            contentImageView.isHidden = false
        } else {
            contentImageView.isHidden = true
        }
    }
    
}
