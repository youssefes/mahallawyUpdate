//
//  homeViewModel.swift
//  delivery
//
//  Created by youssef on 3/14/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Alamofire

class mapViewModel{
    
    var ArrayOfCartData : [Cart]
    init(CartData : [Cart]) {
        self.ArrayOfCartData = CartData
    }

}
