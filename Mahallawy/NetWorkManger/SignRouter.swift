//
//  signRouter.swift
//  Opportunities
//
//  Created by youssef on 12/21/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import Alamofire

enum SignRouter: APIRouter {
    
    case SignUp
    case getCategories
    case ChangeStatus(params  :Parameters)
    
    
    var method: HTTPMethod {
        switch self {
        case .SignUp , .ChangeStatus:
            return .post
        case .getCategories:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .SignUp:
            return "register.php"
        case .getCategories:
            return "getCategories.php"

        case .ChangeStatus:
            return "changeOrderStatues.php"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .SignUp:
            return nil
        case .getCategories:
            return nil
 
        case .ChangeStatus(params: let params):
            print(params)
            return params
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .SignUp , .getCategories:
            return JSONEncoding.default
        case .ChangeStatus:
            return URLEncoding.httpBody
        }
    }
    
    var header: HTTPHeaders {
          switch self {
          case .getCategories , .ChangeStatus :
            let header = HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")])
              return header
            
          case .SignUp :
            let header = HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=UTF-8")])
            return header
        }
      }


}
