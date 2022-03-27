//
//  ExploreCatgoriesSelectedViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift

class ExploreCatgoriesSelectedViewModel {
    
    private let bag = DisposeBag()
    var barndData : [Brand]
    var catId : String
    init(brands : [Brand], catId: String) {
        self.barndData = brands
        self.catId = catId
    }

    func getBrands(complaation : @escaping(_ resulte : [Brand])->Void){
        complaation(barndData)
    }
    
    
    
}
