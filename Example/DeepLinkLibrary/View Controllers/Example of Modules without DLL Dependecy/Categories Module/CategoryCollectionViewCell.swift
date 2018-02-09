//
//  CategoryCollectionViewCell.swift
//  TheBay
//
//  Created by Giuseppe Lanza on 08/02/18.
//  Copyright © 2018 Gilt. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var selectedIndicatorView: UIView!
    
    override var isSelected: Bool {
        didSet {
            selectedIndicatorView.backgroundColor = isSelected ? tintColor : .clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedIndicatorView.backgroundColor = .clear
    }
}
