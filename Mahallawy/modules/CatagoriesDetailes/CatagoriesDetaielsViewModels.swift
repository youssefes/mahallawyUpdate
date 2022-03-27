//
//  CatagoriesDetaielsViewModels.swift
//  Mahallawy
//
//  Created by youssef on 3/30/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class CatagoriesDetaielsViewModels {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    var catagory :  Brand?
    var catagorySub : AdSubCatagories?
    var catId : String
    var isMyAddverisment : Bool
    private var SeccessRequestAddToFav : PublishSubject<ForgetPasswordModel> = .init()
     lazy var SeccessRequestAddToFavObservable : Observable<ForgetPasswordModel> = SeccessRequestAddToFav.asObservable()
    
    
    var SeccessDeleteAddvertisment : PublishSubject<ForgetPasswordModel> = .init()
    private var SeccessRequestAddRating : PublishSubject<RatingModel> = .init()
    lazy var SeccessRequestAddRatingObservable : Observable<RatingModel> = SeccessRequestAddRating.asObservable()
    
    private var SeccessGetBrandDverisment : PublishSubject<[AdSubCatagories]> = .init()
       lazy var SeccessGetBrandDverismentObservable : Observable<[AdSubCatagories]> = SeccessGetBrandDverisment.asObservable()
    
    
    
    init(catagorie : Brand? , catagorySub : AdSubCatagories?, isMyAddverisment : Bool, catId : String) {
        self.catagory = catagorie
        self.catagorySub = catagorySub
        self.isMyAddverisment = isMyAddverisment
        self.catId = catId
    }
   
    
    func getBrands(complaation : @escaping(_ catagory : Brand?,_ catagorySub : AdSubCatagories? ,_ MyAddverisment : Bool)->Void){
        complaation(catagory,catagorySub,isMyAddverisment)
    }
    
    func addToCart(parameters : [String : String])-> Observable<AddToCartModel>{
        Observable<AddToCartModel>.create { [weak self] (itmes) -> Disposable in
            self?.signRepository.AddtoCart(parameters: parameters) { (resulte) in
                switch resulte{
                case .success(let data):
                    itmes.onNext(data)
                    itmes.onCompleted()
                case .failure(let error):
                    itmes.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func addLikeAndUnlike(parameters : [String : String])-> Observable<ForgetPasswordMainModel> {
        Observable<ForgetPasswordMainModel>.create { [weak self] (itmes) -> Disposable in
            self?.signRepository.addLikeAndUnlike(parameters: parameters) { (resulte) in
                switch resulte{
                case .success(let data):
                    itmes.onNext(data)
                    itmes.onCompleted()
                case .failure(let error):
                    itmes.onError(error)
                }
            }
            return Disposables.create()
        }
        
        
    }
    
    func addToFavourit(parameters : [String : String]){
        signRepository.addToFavouirts(parameters: parameters) { [weak self] (reselst) in
            guard let self = self else {return}
            switch reselst{
            case .success( let ResultData):
                self.SeccessRequestAddToFav.onNext(ResultData)
            case .failure(let error):
                 self.SeccessRequestAddToFav.onError(error)
            }
        }
    }
    
    func addRating (parameters : [String : String]){
        signRepository.addRate(parameters: parameters) { [weak self] (reselst) in
            guard let self = self else {return}
            switch reselst{
            case .success( let ResultData):
                self.SeccessRequestAddRating.onNext(ResultData)
            case .failure(let error):
                self.SeccessRequestAddRating.onError(error)
            }
        }
    }
    
    func getBrandAddvertisment(parameters : [String : String]){
        signRepository.GetBrandAddvertisment(parameters: parameters) { [weak self]  (respondData) in
             guard let self = self else {return}
            switch respondData{
            case .success( let advertisments):
                guard let adds = advertisments.ads else {return}
                self.SeccessGetBrandDverisment.onNext(adds)
                self.SeccessGetBrandDverisment.onCompleted()
            case .failure(let error):
                print(error)
                self.SeccessGetBrandDverisment.onError(error)
                self.SeccessGetBrandDverisment.onCompleted()
            }
        }
        
    }
    
    func addView(parameters : [String : String]){
        signRepository.addView(parameters: parameters) { (resulte) in
            print(resulte)
        }
    }
    
    
    func DeleteAddvertisment(addvertiseId : String){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else{return}
        let Params : [String: String] = [
            "adv_id" : addvertiseId,
            "user_id" : userId
        ]
        
        signRepository.DeleteAddvertisment(parameters: Params) { [weak self] (reselst) in
            guard let self = self else {return}
            switch reselst{
            case .success( let ResultData):
                self.SeccessDeleteAddvertisment.onNext(ResultData)
            case .failure(let error):
                self.SeccessDeleteAddvertisment.onError(error)
            }
        }
    }
    
    
}
