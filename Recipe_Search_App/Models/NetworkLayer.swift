//
//  NetworkLayer.swift
//  SportsApplication
//
//  Created by moutaz hegazy on 3/5/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLayer{
    public static func fetchData(from urlStr:String,onCompletion handler : ((Data?,AFError?)->())?){
        let request = AF.request(urlStr)

        request.responseData { (response) in
            if(response.error != nil){
                handler?(nil,response.error)
            }else{
                handler?(response.data,nil)
            }
        }
    }
}
