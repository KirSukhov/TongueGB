//
//  MainScenePresenter.swift
//  ЯзыкЪ
//
//  Created by Ярослав on 01.05.2022.
//

import UIKit
import Firebase

// MARK: - Presenter
final class MainScenePresenter {
    weak var viewDelegate: MainSceneViewDelegate?
    
    // MARK: - Services
    private let firebaseAPI: FirebaseAPI
    
    // MARK: - Initializers
    init(_ firebaseAPI: FirebaseAPI) {
        self.firebaseAPI = firebaseAPI
    }
    
    // MARK: - Public methods
    func storeAddedWordCardToFirebase(word: String, translation: String, transcription: String, category: String) {
        guard let userEmail = firebaseAPI.authService.currentUser?.email else { return }
        
        let card = CardFirebase(word: word, translation: translation, transcription: transcription, category: category, userEmail: userEmail)
        firebaseAPI.storeWordCard(card)
    }
    
    func fetchCardsFromFirebase(_ controller: UIViewController, completion: @escaping ([CardFirebase]?) -> Void) {
        var cards: [CardFirebase] = []
        firebaseAPI.fetchWordCardsArray { cardsFirebase in
            guard let cardsFirebase = cardsFirebase else { return }
            cards = cardsFirebase
            
            if cards.isEmpty {
                completion(nil)
            } else {
                completion(cards)
            }
        }
    }
}
