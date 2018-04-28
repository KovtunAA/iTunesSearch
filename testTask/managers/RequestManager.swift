//
//  RequestManager.swift
//  testTask
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 kovtuns. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestManager {
    
    private struct RequestManagerConstants{
        static let fullApiPath = "https://itunes.apple.com"
        static let apiRequests = "/search"
        
        struct UrlConstants {
            static var searchUrl: (_ term: String, _ media: String) -> String = {
//                https://itunes.apple.com/search?term=paulclark&media=software
                
                "\(RequestManagerConstants.fullApiPath)\(RequestManagerConstants.apiRequests)?term=\($0)&media=\($1)"
            }
        }
    }
    
    static let sharedInstance = RequestManager()

    func getSearchList(term: String, media: String, _ completion: @escaping ([String : Any]?, Error?)->()){
        Alamofire.request(RequestManagerConstants.UrlConstants.searchUrl(term, media), method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let jsonValue):
                let json = JSON(jsonValue)
                completion(json.dictionaryObject, nil)
            case .failure(let errorResponse):
                completion(nil, errorResponse)
            }
        }
    }
}
