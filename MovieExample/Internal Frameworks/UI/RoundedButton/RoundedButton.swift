//
// Created by Eugene Kazaev on 2019-09-02.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class RoundedButton: UIButton {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    private func setupDefaults() {
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        layer.masksToBounds = true
    }

    private func getImage(for color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image;
    }

    @IBInspectable public var buttonColor: UIColor = UIColor.blue {
        didSet {
            setBackgroundImage(getImage(for: buttonColor), for: .normal)
        }
    }

    public override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            layer.cornerRadius = min(newValue.width, newValue.height) / 2
        }
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        let isInactive = self.tintAdjustmentMode == UIView.TintAdjustmentMode.dimmed;
        if isInactive {
            setBackgroundImage(getImage(for: tintColor), for: .normal)
        } else {
            setBackgroundImage(getImage(for: buttonColor), for: .normal)
        }
    }
}
