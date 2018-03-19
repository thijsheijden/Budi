//
//  RoundedShadowView.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/19/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import Foundation
import UIKit

class RoundedShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 20
    }
    
}
