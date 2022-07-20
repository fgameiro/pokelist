//
//  ListingViewCellCollectionViewCell.swift
//  PokeList
//
//  Created by Felipe Gameiro on 19/07/22.
//

import UIKit

class ListingCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    static let identifier: String = "ListingCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(8)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    

}
