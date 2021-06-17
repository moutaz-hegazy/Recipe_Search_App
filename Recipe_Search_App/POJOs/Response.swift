//
//  Response.swift
//  Recipe_Search_App
//
//  Created by moutaz hegazy on 6/17/21.
//

import Foundation

struct Response : Decodable{
    var q : String?
    var from : Int?
    var to : Int?
    var more : Bool?
    var count : Int?
    var hits : [Dictionary<String,Recipe>]?
}
