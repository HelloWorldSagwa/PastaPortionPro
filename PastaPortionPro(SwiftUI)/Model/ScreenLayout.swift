//
//  ScreenLayout.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/07/28.
//

import Foundation


struct ScreenLayout{
    
    var diameter : CGFloat = 250

//    var screenSize : CGSize = .zero
// 기기정보 불러서 거기에 맞는값 넣는 수 밖에 없을듯!
    
    func pointToCm (pointValue : Double?) -> Double{
        
        let cmValue = round((pointValue ?? 0.0) * 0.016 * 100) / 100
        return cmValue
        
    }
    
}
