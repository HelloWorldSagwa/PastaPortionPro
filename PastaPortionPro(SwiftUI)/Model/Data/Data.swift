//
//  Data.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 1/11/24.
//

import Foundation
import Combine
import RealmSwift


class PresentData : ObservableObject {
    
    @Published var currentView : String = "LogIn"
    
    @Published var _id : ObjectId?
    
    @Published var name : String = "Unknown"
    @Published var pastaPoint : Double = 1.0
    @Published var pastaTimer : Double = 8.0 * 60 // 기본 파스타 타이머 지정
    
    @Published var isPresented : Bool = false
    
    @Published var premiumAccess : Bool = false
    
    
}
