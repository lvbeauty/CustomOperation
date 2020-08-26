//
//  CollectionViewCell.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var highLightIndicator: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            highLightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highLightIndicator.isHidden = !isSelected
        }
    }
}
