//
//  ExploreCatagoriesViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class ExploreCatagoriesViewModel {
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()

    private var SeccessgetCatagories : PublishSubject<[CategoriesE]> = .init()
    lazy var  SeccessgetCatagoriesObservable : Observable<[CategoriesE]> = SeccessgetCatagories.asObservable()
    
    
    func ExploreCatagories()  {
        
        var para : [String : String] = [:]
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String{
            para =  [
                "user_id" : userId
            ]
        } else {
            guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
            para =  [
                "user_id" : id
            ]
        }
        
         
        
        signRepository.ExploreCatagories(parameters: para) { [weak self](resultExplore) in
            guard let self = self else {return}
            switch resultExplore {
            case .success(let data):
                print(resultExplore)
                 let categoriesE = data.categories
                self.SeccessgetCatagories.onNext(categoriesE)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
