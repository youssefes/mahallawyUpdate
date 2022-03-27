//
//  ContectUsViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ContectUsViewModel{
    
    var signRepository = SignRepository()
       let disposedBag = DisposeBag()
       
    
    private var SeccessgetContect : PublishSubject<contectUsModel> = .init()
       lazy var  SeccessgetContectObservable : Observable<contectUsModel> = SeccessgetContect.asObservable()
    
       func ContectUS(Paras : [String : String]){
           signRepository.contecUs(parameters: Paras) { [weak self] (resulte) in
            guard let self = self else {return}
            switch resulte{
            case .success(let data):
                self.SeccessgetContect.onNext(data)
            case .failure(let error):
                self.SeccessgetContect.onError(error)
            }
           }
       }
    
}
