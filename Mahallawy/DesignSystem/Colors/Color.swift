//
//  Coler.swift
//  Opportunities
//
//  Created by youssef on 12/1/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit

extension DesignSystem {
    enum Colors : String {
        case Title = "Title"
        case SubTitle = "SubTitle"
        case Difination = "Difination"
        case backGroundButton = "backGroundButton"
        case MainbuttonColor = "MainbuttonColor"
        case LabelColor = "LabelColor"
        case textFieldColorBackGround = "textFieldColorBackGround"
        case BackGround = "BackGround"
        case white = "White"
        case SelectedColor = "SelectedColor"
        case Colorclear = "Colorclear"
        case loseColor = "loseColor"
        case typeTransactionCellProfile = "typeTransactionCellProfile"
        case loseColorBackground = "loseColorBackground"
        case plachHolderColor = "plachHolderColor"
        case MainColor = "MainColor"
        var color : UIColor {
            switch self {
            case .Title:
                print(self.rawValue)
                return UIColor(named : self.rawValue)!
            case .SubTitle:
                return UIColor(named : self.rawValue)!
            case .Difination:
                return UIColor(named : self.rawValue)!
            case .backGroundButton:
                return UIColor(named : self.rawValue)!
            case .MainbuttonColor:
                return UIColor(named : self.rawValue)!
            case .LabelColor:
                return UIColor(named : self.rawValue)!
            case .textFieldColorBackGround:
                 return UIColor(named : self.rawValue)!
            case .white:
                return UIColor(named : self.rawValue)!
            case .BackGround:
                 return UIColor(named : self.rawValue)!
            case .SelectedColor:
                return UIColor(named : self.rawValue)!
            case .Colorclear:
                 return UIColor(named : self.rawValue)!
            case .loseColor:
                return UIColor(named : self.rawValue)!
            case .typeTransactionCellProfile:
                return UIColor(named : self.rawValue)!
            case .loseColorBackground:
                 return UIColor(named : self.rawValue)!
            case .plachHolderColor:
                return UIColor(named : self.rawValue)!
            case .MainColor:
                return UIColor(named : self.rawValue)!
            }
        }
        
    }
}
