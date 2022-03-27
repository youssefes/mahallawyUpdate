//
//  registerViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/12/21.
//  Copyright © 2021 youssef. All rights reserved.
//
import Foundation
import RxSwift
import Alamofire

class registerViewModel {
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    var SeccessUpdateBrandProfile : PublishSubject<ForgetPasswordModel> = .init()
    
    private var SeccessgetCatagories : PublishSubject<CatagoriesModels> = .init()
    lazy var  SeccessgetCatagoriesObservable : Observable<CatagoriesModels> = SeccessgetCatagories.asObservable()
    
    var BarndData : Info?
    init(BarndData : Info?) {
        self.BarndData = BarndData
    }
    
    func uplaodImages(images : UIImage) -> Observable<UploadImageModel>{
        return signRepository.uplaodImages(images: images).asObservable()
    }
    
    
    func register(postData : [String: String])->  Observable<RegisterAsUserModel> {
        Observable<RegisterAsUserModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.register(parameters: postData) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func RegisterAsDelivery(postData : [String: String])->  Observable<LoginModel> {
        Observable<LoginModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.RgisterAsDelivery(parameters: postData) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCatagories()  {
        signRepository.getCatagories().subscribe(onNext: { (catagories) in
            self.SeccessgetCatagories.onNext(catagories)
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            self.SeccessgetCatagories.onError(error)
        }).disposed(by: disposedBag)
    }
    
    
    func updatabrandProfile(parameters : [String: String])->  Observable<ForgetPasswordModel> {
        Observable<ForgetPasswordModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.updateBrand(parameters: parameters) { (resulte) in
                switch resulte{
                case .success(let respondData):
                    items.onNext(respondData)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
    func loginUsigFaceBooke(postData : [String : String]) ->  Observable<RegisterAsUserModel> {
        Observable<RegisterAsUserModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.register(parameters: postData) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
