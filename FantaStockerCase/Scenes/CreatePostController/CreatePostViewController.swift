//
//  CreatePostViewController.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 11.04.2022.
//

import Foundation
import UIKit

protocol CreatePostViewControllerDelegate: AnyObject {
    func dismissCreateViewController()
}

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var viewModel: CreatePostViewModelProtocol?
    weak var delegate: CreatePostViewControllerDelegate?
    
    var dismissButton: FSButton = {
        let button = FSButton()
        button.setTitle("Cancel", for: .normal)
        button.titleColor = .black
        button.addTarget(self, action: #selector(dismis), for: .touchUpInside)
        button.selectedFont = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    var postButton: FSButton = {
        let button = FSButton()
        button.setTitle("Post", for: .normal)
        button.addTarget(self, action: #selector(post), for: .touchUpInside)
        button.isEnabled = false
        button.selectedFont = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    var addMediaButton: FSButton = {
        let button = FSButton()
        button.cornerRadius = 8
        button.setImage(UIImage(named: "gallery"), for: .normal)
        button.addTarget(self, action: #selector(mediaButtonAction), for: .touchUpInside)
        return button
    }()
    
    var postTextView: FSTextView = {
        let textView = FSTextView()
        textView.cornerRadius = 8
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init(viewModel: CreatePostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        applyUI()
    }
    
    func applyUI() {
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(60)
        }
        
        view.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(60)
        }
        
        view.addSubview(addMediaButton)
        addMediaButton.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(20)
            make.leading.equalTo(dismissButton.snp.leading)
        }
        
        view.addSubview(postTextView)
        postTextView.delegate = self
        postTextView.snp.makeConstraints { make in
            make.top.equalTo(addMediaButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }

    }
    
    @objc func dismis() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        
        viewModel?.uploadPost { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.delegate?.dismissCreateViewController()
            })
        }
    }
    
    
    @objc func mediaButtonAction() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let self = self,  let image = info[.originalImage] as? UIImage else {
                return
            }
            
            let resizedImage = self.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
            
            self.contentImageView.image = resizedImage
            self.view.insertSubview(self.contentImageView, aboveSubview: self.postTextView)
            
            self.postButton.isEnabled = (self.postTextView.text != "") || (self.contentImageView.image != nil)
            
            self.viewModel?.post.image = resizedImage?.pngData()
            
            self.contentImageView.snp.makeConstraints { make in
                make.top.equalTo(self.postTextView.snp.bottom).offset(10)
                make.leading.equalTo(self.postTextView.snp.leading)
                make.trailing.equalTo(self.postTextView.snp.trailing)
                make.height.equalTo(150)
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        postButton.isEnabled = (textView.text != "") || (contentImageView.image != nil)
        viewModel?.post.text = textView.text
    }
    
}
