//
//  RecipeDetailsViewController.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/19/21.
//

import UIKit
import SDWebImage
import SafariServices

class RecipeDetailsViewController: UIViewController, SFSafariViewControllerDelegate{

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var recipe : Recipe?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let r = recipe{
            titleLbl?.text = r.title
            ingredientsTableView.reloadData()
            if let image = r.image{
                recipeImageView?.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: "placeholder.png"))
            }else{
                recipeImageView.image = UIImage(named: "recipeImage")
            }
        }
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareLink(_ sender: UIBarButtonItem) {
        
        if let sourceUrl = recipe?.url {
            let objectsToShare: [String] = [sourceUrl]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = recipeImageView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openRecipeUrl(_ sender: UIButton) {
        
        if let urlString = recipe?.url, let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}


//MARK: - table view delegate & data source.
extension RecipeDetailsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingerdients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        cell.textLabel?.text = recipe?.ingerdients?[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
