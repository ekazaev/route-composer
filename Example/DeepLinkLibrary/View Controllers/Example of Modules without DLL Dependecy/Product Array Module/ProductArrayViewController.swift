//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ProductArrayViewController: UICollectionViewController {
    var products = [ProductArrayProductProtocol]()
    var fetcher: ProductArrayProductFetching?

    var categoryId: String? {
        didSet {
            guard oldValue != categoryId else {
                return
            }
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Product Array"
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        }
        reloadData()
    }

    private func reloadData(){
        guard isViewLoaded, let categoryId = categoryId else {
            return
        }

        fetcher?.fetch(categoryId: categoryId, withCompletion: {[weak self] (products) in
            self?.products = products
            self?.collectionView?.reloadData()
        })
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productArrayCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.item]
        cell.setup(with: product)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productLabel: UILabel!

    func setup(with product: ProductArrayProductProtocol) {
        productLabel.text = "\(product.name)\n\(product.price)"
    }

}