//
//  ProfileSelectionViewModel.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 9.04.2022.
//

import Foundation


import Foundation

protocol ProfileSelectionViewModelProtocol {
    var users: [User] { get }
}

class ProfileSelectionViewModel: ProfileSelectionViewModelProtocol {
    
    var users: [User] = []
    
    init(users: [User]) {
        self.users = users
    }
    
}
