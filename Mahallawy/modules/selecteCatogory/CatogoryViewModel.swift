//
//  CatogoryViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class CatogoryViewModel {
    var signRepository = SignRepository()
       let disposedBag = DisposeBag()
    
    var catagoryId : String
    var catagoryName : BehaviorSubject<String> = .init(value: "")
    var isAdvertisment : Bool
    init(catagoryId : String, catagoryName : String , isAdvertisment : Bool) {
        self.catagoryId = catagoryId
        self.catagoryName.onNext(catagoryName)
        self.isAdvertisment  = isAdvertisment 
    }
    
    
    func getSubCatagories(complation: @escaping (_ AddsData : [AdSubCatagories]?)->Void) {
        
        var parameters :  [String: String] = [:]
        
        if let id = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String {
            parameters = [
                "catid" : catagoryId,
                "user_id" : id
            ]
        }else {
            guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
            parameters  = [
                "catid" : catagoryId,
                "user_id" : id
            ]
            
        }
     
        signRepository.SubCatagories(parameters: parameters) { (resulet) in
            switch resulet{
            case .success(let resulteData):
                guard let status = resulteData.info?.first?.status else {return}
                if status {
                    guard let ads = resulteData.ads else {return}
                   complation(ads)
                }
            case .failure(let error):
                complation(nil)
                print(error)
            }
        }
        
    }
    
    func getLatestAdvertises(complation: @escaping (_ AddsData : [AdSubCatagories]?)->Void) {
        
        var parameters :  [String: String] = [:]
        
        if let id = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String {
            parameters = [
                "user_id" : id
            ]
        }else {
            guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
            parameters  = [
                "user_id" : id
            ]
            
        }
        signRepository.getLatestAdvertises(parameters: parameters) { (resulet) in
            switch resulet{
            case .success(let resulteData):
                guard let status = resulteData.info?.first?.status else {return}
                if status {
                    guard let ads = resulteData.ads else {return}
                   complation(ads)
                }
            case .failure(let error):
                complation(nil)
                print(error)
            }
        }
        
    }
}
