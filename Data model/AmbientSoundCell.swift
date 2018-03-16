//
//  AmbientSoundCell.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/14/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit

class AmbientSoundCell: UITableViewCell {

    //MARK: Setting the properties of the cell
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var soundImage: UIImageView!
    @IBOutlet weak var soundNameLabel: UILabel!
    @IBOutlet weak var soundToggleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    
}
