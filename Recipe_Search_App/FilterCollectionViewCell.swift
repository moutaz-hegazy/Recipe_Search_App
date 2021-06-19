//
//  FilterCollectionViewCell.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/15/21.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLbl: UILabel!{
        didSet{
            cellLbl.layer.borderWidth = 0.5
            cellLbl.layer.cornerRadius = 16
            cellLbl.clipsToBounds = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellLbl.backgroundColor = .white
        cellLbl.textColor = .black
    }
}
