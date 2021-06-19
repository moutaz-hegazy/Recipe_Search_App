//
//  NetworkViewmodel.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/17/21.
//

import Foundation

struct NetworkViewmodel {
    
    private let path = UserDefaults.standard
    
    var searchHistory : [String]{
        get{
             return path.array(forKey: "searchHistory") as? [String] ?? []
        }
        set(newValue){
            path.setValue(newValue, forKey: "searchHistory")
        }
    }
    
    func fetchRecipes(for ingredient : String,with filter : String? = nil,
                      from beginIndex : Int = 0, to endIndex : Int = 10,
                      onSuccessBinding : @escaping([Recipe])->(),
                      onFailBinding: @escaping()->()){
        var requestFilter = ""
        if(filter != nil && !filter!.isEmpty){
            requestFilter = "&health=\(filter!)"
        }
        print("https://api.edamam.com/search?q=\(ingredient.replacingOccurrences(of: " ", with: "-"))&app_id=\(Constants.AppID)&app_key=\(Constants.AppKey)&from=\(beginIndex)&to=\(endIndex)\(requestFilter)")
        NetworkLayer.fetchData(from:"https://api.edamam.com/search?q=\(ingredient.replacingOccurrences(of: " ", with: "-"))&app_id=\(Constants.AppID)&app_key=\(Constants.AppKey)&from=\(beginIndex)&to=\(endIndex)\(requestFilter)"){
            data,error in
            if(error != nil){
                onFailBinding()
                return
            }
            let response = try? JSONDecoder().decode(Response.self, from: data!)
            if let resultData = response{
                let recipes = resultData.hits?.map({ (input) -> Recipe in
                    return input["recipe"]!
                })
                DispatchQueue.main.async {
                    onSuccessBinding(recipes!)
                }
            }
        }
    }
}
