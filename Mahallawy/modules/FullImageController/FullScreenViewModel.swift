//
//  FullScreenViewModel.swift
//  Mahallawy
//
//  Created by youssef on 4/21/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class FullScreenViewModel {
    
    var arrayOfImage : BehaviorRelay<[String]> = .init(value: [])
    init(arrayOfImage : [String]) {
        self.arrayOfImage.accept(arrayOfImage)
    }
}
