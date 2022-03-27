//
//  Typography.swift
//  Opportunities
//
//  Created by youssef on 12/1/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit

extension DesignSystem {
    enum Typography {
        case Title
        case Title2
        case Discription
        case SegmentControl
        case login
        private var fontDiscriptor : CustomFontDiscriptor {
            switch self {
            case .Title:
                return CustomFontDiscriptor(font: .Bold, size: 20, Style: .body)
            case .Title2:
                return CustomFontDiscriptor(font: .Black, size: 25, Style: .title2)
            case .Discription:
                return CustomFontDiscriptor(font: .Light, size: 18, Style: .title2)
            case .SegmentControl:
                return CustomFontDiscriptor(font: .Bold, size: 15, Style: .body)
            case .login :
                return CustomFontDiscriptor(font: .Light, size: 20, Style: .body)
            }
        }
        
        var font : UIFont {
            guard let font = UIFont(name: fontDiscriptor.font.name, size: fontDiscriptor.size) else{
                return UIFont.preferredFont(forTextStyle: fontDiscriptor.Style)
            }
            
            let fontMatrix = UIFontMetrics(forTextStyle: fontDiscriptor.Style)
            return fontMatrix.scaledFont(for: font)
        }
    }
}
