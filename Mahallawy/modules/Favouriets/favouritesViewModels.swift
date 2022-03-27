//
//  favouritesViewModels.swift
//  Mahallawy
//
//  Created by youssef on 4/8/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class favouritesViewModel {
    
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    private var barndData : PublishSubject<[Follower]> = .init()
    lazy var  barndDataObservable : Observable<[Follower]> = barndData.asObservable()
       
    func GetFavourite (parameters : [String: String]){
        signRepository.GetFavourite(parameters: parameters) { (resuletData) in
            switch resuletData {
            case .success(let data):
                guard let dataBrand = data.followers else {return}
                self.barndData.onNext(dataBrand)
            case .failure(let error):
                self.barndData.onError(error)
            }
        }
    }
    
}
