//
//  HomeViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/20/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class HomeViewModel{
    
     var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    func getCatagories()  -> Observable<CatagoriesModels>{
        Observable<CatagoriesModels>.create { [weak self] (items) -> Disposable in
            self?.signRepository.getCatagories().subscribe(onNext: { (catagories) in
                items.onNext(catagories)
            }, onError: { (error) in
                items.onError(error)
            }).disposed(by: self!.disposedBag)
            
            return Disposables.create()
        }
        
      
    }
    
    func updateFCMToken(parameters: [String : String])  {
        signRepository.SendFCMToken(parameters: parameters) { (resulte) in }
    }
    
    func DeliveryAvaliableornot(parameters: [String : String]) -> Observable<DelivaeryStatusModel>{
        Observable<DelivaeryStatusModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.DeliveryAvaliableornot(parameters: parameters, completion: { (resulte) in
                switch resulte{
                case .success(let delivermodel):
                    items.onNext(delivermodel)
                case .failure(let error):
                    items.onError(error)
                }
            })
            
            return Disposables.create()
        }
    }
    
    func CheckDeliveryStausAcceptOrNot(parameters: [String : String]) -> Observable<CheckStausOfDeliveryModel>{
        Observable<CheckStausOfDeliveryModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.CheckStatusOfDelivery(parameters: parameters, completion: { (resulte) in
                switch resulte{
                case .success(let delivermodel):
                    items.onNext(delivermodel)
                case .failure(let error):
                    items.onError(error)
                }
            })
            
            return Disposables.create()
        }
    }
    
}
