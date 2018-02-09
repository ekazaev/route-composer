//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var selectorCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!

    weak var delegate: CategoriesViewControllerDelegate?

    var categories = [CategoryProtocol]()

    var categoryId: String? {
        didSet {
            guard oldValue != categoryId, let categoryId = categoryId else {
                return
            }
            self.showCategory(categoryId)
        }
    }

    var fetcher: CategoriesFetching!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"

        fetcher.fetch { [weak self] (categories) in
            guard let `self` = self else {
                return
            }
            self.categories = categories
            let categoryId = self.categoryId ?? categories.first?.id
            if let categoryId = categoryId {
                self.showCategory(categoryId)
            }
        }
    }

    private func showCategory(_ categoryId: String) {
        self.categoryId = categoryId
        delegate?.showCategory(for: categoryId)
    }

}

extension CategoriesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]

        cell.categoryTitleLabel.text = category.name

        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        showCategory(category.id)
    }

}