//
//  ViewController.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/14/21.
//

import UIKit
import DropDown

class RecipesViewController: UIViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var recipesTableView: UITableView!
    
    private var data: [String] = ["apple","appear","Azhar","code","BCom"]
    private var dataFiltered: [String] = []
    private var dropButton = DropDown()
    private var dropDown = DropDown()
    private lazy var filterData : [String] = {
        var array = ["All"]
        array.append(contentsOf: Constants.filterOptions.keys.map{$0}.sorted())
        return array
    }()
    private lazy var networkViewmodel : NetworkViewmodel = {
        NetworkViewmodel()
    }()
    private var selectedCell : IndexPath = [0,0]{
        willSet{
            if let cell = filterCollectionView.cellForItem(at: selectedCell) as? FilterCollectionViewCell{
                cell.cellLbl.backgroundColor = .white
                cell.cellLbl.textColor = .black
            }
            if let nextCell = filterCollectionView.cellForItem(at: newValue) as? FilterCollectionViewCell{
                nextCell.cellLbl.backgroundColor = .blue
                nextCell.cellLbl.textColor = .white
            }
        }
    }
    private var fetchedRecipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataFiltered = data
        dropButton.anchorView = searchBar
        dropButton.bottomOffset = CGPoint(x: 0, y:(searchBar.bounds.minY + 90))
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom

        dropButton.selectionAction = { [weak self](index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self?.searchBar.text = item
            self?.filterCollectionView.isHidden = false
        }
    }
}


//MARK: -searchBar delegate methods.
extension RecipesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == " "){
            searchBar.text = ""
        }else if let lastChar = searchText.last, String(lastChar).containsSpecialCharacter{
            searchBar.text = String(searchText[..<searchText.index(before: searchText.endIndex)])
        }else{
            print("none")
        }
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })
        dropButton.dataSource = dataFiltered
        dropButton.show()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dropButton.dataSource = dataFiltered
        dropButton.show()
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataFiltered = data
        dropButton.hide()
        filterCollectionView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterCollectionView.isHidden = false
        networkViewmodel.fetchRecipes(for: "chicken", with: "keto-friendly",onSuccessBinding: {
            [weak self](recipes) in
            self?.fetchedRecipes.append(contentsOf: recipes)
            self?.recipesTableView.reloadData()
        },onFailBinding: {})
    }
}


//MARK: - collectionview delegate & datasource methods
extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)
        
        if let filterCell = cell as? FilterCollectionViewCell{
            filterCell.cellLbl.text = filterData[indexPath.item]
            if(indexPath == selectedCell){
                filterCell.cellLbl.backgroundColor = .blue
                filterCell.cellLbl.textColor = .white
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath
    }

}

//MARK: -tableview delegate & datasource methods
extension RecipesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        if let recipeCell = cell as? RecipeTableViewCell{
            recipeCell.displayRecipeData(for: fetchedRecipes[indexPath.row])
        }
        return cell
    }
}


extension String {
   var containsSpecialCharacter: Bool {
      let regex = "[^A-Za-z ]"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}
