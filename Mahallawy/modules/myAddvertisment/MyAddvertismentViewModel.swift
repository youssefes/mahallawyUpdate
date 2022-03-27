//
//  MyAddvertismentViewModel.swift
//  Mahallawy
//
//  Created by youssef on 4/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MyAddvertismentViewModel {
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    var SeccessGetBrandDverisment : PublishSubject<[AdSubCatagories]> = .init()
    
    func getMyAddvertisMent(parameters : [String : String]){
        signRepository.MyAddvertisment(parameters: parameters) { [weak self] (MyAddvertismetResulet) in
            guard let self = self else {return}
            switch MyAddvertismetResulet{
            case .success( let advertisments):
                guard let adds = advertisments.ads else {return}
                self.SeccessGetBrandDverisment.onNext(adds)
            case .failure(let error):
                self.SeccessGetBrandDverisment.onError(error)
            }
        }
    }
}
