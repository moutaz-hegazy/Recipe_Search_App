//
//  ViewController.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/14/21.
//

import UIKit
import DropDown

class ViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var data: [String] = ["apple","appear","Azhar","code","BCom"]
    var dataFiltered: [String] = []
    var dropButton = DropDown()
    var dropDown = DropDown()
    var filterData = ["All","vegan","kito"]
    
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
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
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
    }

}


//MARK: - collectionview delegate & datasource methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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
        }
        return cell
    }
}

