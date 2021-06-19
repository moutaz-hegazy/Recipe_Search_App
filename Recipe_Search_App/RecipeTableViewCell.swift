//
//  RecipeTableViewCell.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/18/21.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    @IBOutlet weak var healthLbl: UILabel!
    
    override func prepareForReuse() {
        recipeImageView.image = nil
        titleLbl.text = nil
        sourceLbl.text = nil
        healthLbl.text = nil
    }
    
    func displayRecipeData(for recipe : Recipe){
        
        if let image = recipe.image{
            recipeImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            recipeImageView.image = UIImage(named: "recipeImage")
        }
        titleLbl.text = recipe.title
        sourceLbl.text = recipe.source
        healthLbl.text = recipe.healthLabels?.joined(separator: ", ")
    }
    
}
