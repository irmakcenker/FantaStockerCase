//
//  CreatePostViewModel.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 11.04.2022.
//

import Foundation

protocol CreatePostViewModelProtocol {
    var post: Post { get set }
    func uploadPost(completion: @escaping VoidHandler)
}

class CreatePostViewModel: CreatePostViewModelProtocol {
    var post: Post = Post(context: CoreDataManager.shared.mainContext)
    
    func uploadPost(completion: @escaping VoidHandler) {
        post.owner = CoreDataManager.shared.getSavedUser()
        CoreDataManager.shared.saveContext()

        completion()
    }
}
