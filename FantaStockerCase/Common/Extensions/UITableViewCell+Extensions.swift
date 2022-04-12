//
//  UITableViewCell+Extensions.swift
//  GetirTodo
//
//  Created by cenker.irmak on 12.03.2022.
//

import Foundation
import UIKit

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
