//
//  FSButton.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 11.04.2022.
//

import Foundation
import UIKit

@IBDesignable
class FSButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var titleColor: UIColor = .black {
        didSet {
            setTitleColor(.black, for: .normal)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
           self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
           self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
       didSet{
          self.layer.shadowColor = shadowColor.cgColor
          self.layer.masksToBounds = false
       }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.4 {
       didSet {
          self.layer.masksToBounds = false
          self.layer.shadowOpacity = shadowOpacity
       }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1, height: 4) {
        didSet {
           self.layer.masksToBounds = false
           self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = CGFloat(0.5) {
       didSet {
          self.layer.masksToBounds = false
          self.layer.shadowRadius = shadowRadius
       }
    }
    
    @IBInspectable override var isEnabled: Bool {
       didSet {
           if isEnabled {
               setTitleColor(.black, for: .normal)
           } else {
               setTitleColor(.gray, for: .disabled)
           }
       }
    }
    
    @IBInspectable var selectedFont: UIFont = .systemFont(ofSize: 12) {
       didSet {
           titleLabel?.font = selectedFont
       }
    }

}
