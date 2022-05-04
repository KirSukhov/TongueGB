//
//  MainSceneViewController.swift
//  ЯзыкЪ
//
//  Created by Ярослав on 01.05.2022.
//

import UIKit

// MARK: - Protocol
protocol MainSceneViewDelegate: NSObjectProtocol {
}

// MARK: - Implementation
extension MainSceneViewController: MainSceneViewDelegate {
}

// MARK: - Additional extensions
extension MainSceneViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let pageOffset = ScrollPageController().pageOffset(for: scrollView.contentOffset.x, velocity: velocity.x, in: pageOffsets(in: scrollView)) {
            targetContentOffset.pointee.x = pageOffset
            print(pageOffset)
            //print(pageOffsets(in: scrollView))
        }
    }

    private func pageOffsets(in scrollView: UIScrollView) -> [CGFloat] {
        return cardsStackView.subviews.compactMap { $0 }.map { $0.frame.minX }
    }
}

// MARK: - View controller
class MainSceneViewController: UIViewController {
    lazy var presenter = MainScenePresenter()
    
    // MARK: - Properties
    var frame = CGRect.zero
    
    // MARK: - Methods
    private func createTestCards() -> [Card] {
        return [Card(word: "Juggernaut", translation: "Джаггернаут", description: "[dʒəɡərˌnɔt]", category: Category(categoryKey: "Разное", categoryColor: nil, categoryImage: nil), userEmail: ""), Card(word: "Trifle", translation: "Трайфл", description: "[trʌɪfl]", category: Category(categoryKey: "Еда", categoryColor: nil, categoryImage: nil), userEmail: ""), Card(word: "Syllabub", translation: "Силлабаб", description: "[siləˌbəb]", category: Category(categoryKey: "Еда", categoryColor: nil, categoryImage: nil), userEmail: ""), Card(word: "Wanderlust", translation: "Вандерласт", description: "[wändərˌləst]", category: Category(categoryKey: "Путешествия", categoryColor: nil, categoryImage: nil), userEmail: "")]
    }
    
    private func setupUI() {
        //cardsScrollView.decelerationRate = .fast
        let cards = createTestCards()
        
        for card in cards {
            let cardView = CardView()
            cardView.card = card
            cardsStackView.addArrangedSubview(cardView)
        }
    }
    
    private func setupNavigationOptions() {
        self.tabBarController?.title = "Мои карточки"
    }
    
    // MARK: - Outlets
    @IBOutlet var cardsScrollView: UIScrollView!
    @IBOutlet var cardsStackView: UIStackView!
    
    // MARK: - Actions
    
    // MARK: - Selectors
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDelegate = self
        cardsScrollView.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationOptions()
        
    }
}
