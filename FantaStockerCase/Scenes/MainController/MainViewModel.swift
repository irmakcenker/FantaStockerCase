//
//  MainViewModel.swift
//  FantaStockerCase
//
//  Created by cenker.irmak on 8.04.2022.
//

import Foundation

protocol MainViewModelProtocol {
    var users: [User] { get }
    func loadUsers(completion: @escaping VoidHandler)
    var savedUser: User? { get set }
    var posts: [Post]? { get set }
    func getPosts(completion: @escaping VoidHandler)
}

class MainViewModel: MainViewModelProtocol {
    
    var posts: [Post]?
    var users: [User] = []
    var context = CoreDataManager.shared.mainContext
    var savedUser: User?
    
    func loadUsers(completion: @escaping VoidHandler)  {
        
        do {
            
            var savedUser = try context.fetch(SavedUser.fetchRequest()).first
            
            if savedUser == nil {
                
                let frodo = User(context: context)
                frodo.name = "Frodo"
                frodo.userName = "frodo_baggins"
                frodo.avatar = "frodo"
                
                let bilbo = User(context: context)
                bilbo.name = "Bilbo"
                bilbo.userName = "bilbo_baggins"
                bilbo.avatar = "bilbo"
                
                let gandalf = User(context: context)
                gandalf.name = "Gandalf"
                gandalf.userName = "gandalf_the_grey"
                gandalf.avatar = "gandalf"
                
                savedUser = SavedUser(context: context)
                savedUser?.user = frodo
                CoreDataManager.shared.saveContext()
            }
            
            self.savedUser = savedUser?.user
            self.users = try context.fetch(User.fetchRequest())
            
            
            self.getPosts {
                completion()
            }
        } catch {
            print("fetching error occured")
        }
    }
    
    func getPosts(completion: @escaping VoidHandler) {
        
        do {
            self.posts = try context.fetch(Post.fetchRequest())
            completion()
       
        } catch {
            print("fetching error occured")
        }
        
        completion()
    }
}
