//
//  Extensions.swift
//  XO
//
//  Created by Mohamed Zakout on 11/12/19.
//  Copyright © 2019 Mohamed Zakout. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var corenrs: CGFloat {
        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
        }
    }
}
