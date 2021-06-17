//
//  Recipe.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/17/21.
//

import Foundation

struct Recipe : Decodable {
    var title : String?
    var image : String?
    var source : String?
    var url : String?
    var healthLabels : [String]?
    var ingerdients : [String]?
    
    
    enum CodingKeys : String, CodingKey{
        case title = "label"
        case image = "image"
        case source = "source"
        case url = "url"
        case healthLabels = "healthLabels"
        case ingerdients = "ingredientLines"
        
        
    }
}
