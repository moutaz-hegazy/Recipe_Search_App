//
//  NetworkViewmodel.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/17/21.
//

import Foundation

struct NetworkViewmodel {
    
    func fetchRecipes(for ingredient : String,with filter : String? = nil, onSuccessBinding : @escaping([Recipe])->(), onFailBinding: @escaping()->()){
        var requestFilter = ""
        if(filter != nil && !filter!.isEmpty){
            requestFilter = "&health=\(filter!)"
        }
        NetworkLayer.fetchData(from:"https://api.edamam.com/search?q=\(ingredient.replacingOccurrences(of: " ", with: "-"))&app_id=\(Constants.AppID)&app_key=\(Constants.AppKey)&from=0&to=10\(requestFilter)"){
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
