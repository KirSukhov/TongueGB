//
//  FirebaseAPI.swift
//  ЯзыкЪ
//
//  Created by Denis Kazarin on 04.05.2022.
//


import Foundation
import Firebase
import UIKit


class FirebaseAPI: Firebasable {
    
    //MARK: - Properties
    let controller: UIViewController
    let authService = Auth.auth()
    let databaseService = Database.database()
    var state: AuthStateDidChangeListenerHandle?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    //MARK: - Private funcs
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.controller.present(alert, animated: true, completion: nil)
    }
    
    private func createUser(_ user: UserFirebase) {
        authService.createUser(withEmail: user.userEmail, password: user.userId) { [weak self] _, error in
            guard error == nil else {
                self?.showAlert("Ошибка регистрации", "Ошибка записи нового пользователя в базу данных: \(error?.localizedDescription ?? "неизвестная ошибка")")
                return
            }
        }
    }
    
    private func signInUser(_ user: UserFirebase) {
        authService.signIn(withEmail: user.userEmail, password: user.userId) { [weak self] _, error in
            guard error == nil else {
                self?.showAlert("Ошибка авторизации", "Ошибка авторизации пользователя в базе данных: \(error?.localizedDescription ?? "неизвестная ошибка")")
                return
            }
        }
    }
    
    //MARK: - Protocol funcs
    //MARK: --  UserData funcs
    func authUser(_ user: UserFirebase) {
        
        guard authService.currentUser != nil else {
            createUser(user)
            return }
        if user.userEmail.lowercased() == authService.currentUser?.email {
            signInUser(user)
        } else {
            createUser(user)
        }
    }
    
    func fetchUser(_ userEmail: String) -> UserFirebase? {
        guard let firebaseUser = authService.currentUser else { return nil}
        if userEmail == firebaseUser.email {
            return UserFirebase(userEmail: firebaseUser.email!, userId: firebaseUser.uid)
        } else {
            return nil
        }
    }
    
    //MARK: -- Store Funcs
    
    func storeWordCard(_ card: CardFirebase) {
        authService.addStateDidChangeListener { [weak self] _, user in
            guard let self = self, let userEmail = user?.email, card.userEmail == userEmail else { return }
            let ref = self.databaseService.reference(withPath: userEmail.modifyEmailAddress()).child("cards").child(card.word)
            let value = card.toAnyObject()
            ref.setValue(value)
            self.storeCategory(CategoryFirebase(categoryName: card.category.categoryName))
        }
        
    }
    
    func storeCategory(_ category: CategoryFirebase) {
        authService.addStateDidChangeListener { [weak self] _, user in
            guard let self = self, let userEmail = user?.email else { return }
            let ref = self.databaseService.reference(withPath: userEmail.modifyEmailAddress()).child("categories").child(category.categoryName)
            let value = category.toAnyObject()
            ref.setValue(value)
        }
    }
    
    //MARK: -- Fetch funcs
    
    func fetchWordCard(_ keyWord: String) -> CardFirebase? {
        var ref = DatabaseReference()
        var dataSnapshot = DataSnapshot()
        authService.addStateDidChangeListener { [weak self] _, user in
            guard let self = self, let userEmail = user?.email else { return }
            ref = self.databaseService.reference(withPath: userEmail.modifyEmailAddress()).child("cards").child(keyWord)
        }
        ref.getData { error, snapshot in
                guard error == nil else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                dataSnapshot = snapshot
        }
        let fetchedCard = CardFirebase(snapshot: dataSnapshot)
        return fetchedCard
    }
    
    func fetchWordCardsByCategory(_ category: CategoryFirebase) -> [CardFirebase]? {
        
        return nil
    }

    func fetchCategory(_ category: String) -> CategoryFirebase? {
        
        return nil
    }
    
    func fetchCategoryList(_ userEmail: String) -> [CategoryFirebase]? {
       
        return nil
    }
}
