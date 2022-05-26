//
//  SearchScenePresenter.swift
//  ЯзыкЪ
//
//  Created by Ярослав on 01.05.2022.
//

import UIKit

// MARK: - Presenter
final class SearchScenePresenter {
    weak var viewDelegate: SearchSceneViewDelegate?
    
    // MARK: - Services
    private let firebaseAPI: FirebaseAPI
    
    // MARK: - Initializers
    init(_ firebaseAPI: FirebaseAPI) {
        self.firebaseAPI = firebaseAPI
    }
    
    // MARK: - Public methods
    
    func fetchCategoriesFromFirebase(_ controller: UIViewController, completion: @escaping ([CategoryFirebase]?) -> Void) {
        var categories: [CategoryFirebase] = []
        firebaseAPI.fetchCategoriesList { categoriesFirebase in
            guard let categoriesFirebase = categoriesFirebase else { return }
            categories = categoriesFirebase
            
            if categories.isEmpty {
                completion(nil)
            } else {
                completion(categories)
            }
        }
    }
}
