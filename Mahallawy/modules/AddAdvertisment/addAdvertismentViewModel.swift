//
//  ِييِيرثقفهسةثىف{هثص’خيثم.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class addAdvertismentViewModel {
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    var isFromClient : Bool
    var Addvertise : AdSubCatagories?
    init(Addvertise: AdSubCatagories? , isFromClient : Bool) {
        self.Addvertise = Addvertise
        self.isFromClient = isFromClient
    }
    
    func uplaodImages(images : UIImage) -> Observable<UploadImageModel>{
       return signRepository.uplaodImages(images: images).asObservable()
    }
    
    func addAddvertisment(Paras : [String : String],completion: @escaping ((Result< UploadAddvertismentModel , Error>) -> Void)){
        signRepository.addAdvertisment(parameters: Paras) { (resulte) in
            completion(resulte)
        }
    }
    
    func addAddvertismentForClient(Paras : [String : String],completion: @escaping ((Result< UploadAddvertismentModel , Error>) -> Void)){
        signRepository.addAdvertismentForClient(parameters: Paras) { (resulte) in
            completion(resulte)
        }
    }
    
    func updateAddvertisment(Paras : [String : String],completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        signRepository.updateAddvertisment(parameters: Paras) { (resulte) in
            completion(resulte)
        }
    }

    
}
