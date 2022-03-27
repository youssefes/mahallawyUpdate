//
//  OrderTaierViewModel.swift
//  Mahallawy
//
//  Created by jooo on 10/21/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class OrderTaierViewModel {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    func uplaodImages(images : UIImage) -> Observable<UploadImageModel>{
        return signRepository.uplaodImages(images: images).asObservable()
    }
}
