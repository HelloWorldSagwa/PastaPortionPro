//
//  DataTable.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2/21/24.
//

import Foundation
import RealmSwift

class UserProfile: Object, ObjectKeyIdentifiable  {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var name: String = "Unknown"
    @Persisted var emoji: String = "🐈"
    @Persisted var avgCal: Float = 0.0
    @Persisted var avgPastaPoint: Float = 0.0
    @Persisted var avgRatings: Float = 0.0
    @Persisted var avgMinutes: Float = 0.0
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
 
    @Persisted var customCal: Float = 0.0
    @Persisted var customPastaPoint: Float = 0.0
    @Persisted var customMinutes: Float = 0.0
    
    
    convenience init(name: String, emoji : String, avgCal: Float, avgPastaPoint: Float, avgRatings: Float, avgMinutes: Float, createdAt: Date, updatedAt: Date) {
   
        self.init()
        self.name = name
        self.emoji = emoji
        self.avgCal = avgCal
        self.avgPastaPoint = avgPastaPoint
        self.avgRatings = avgRatings
        self.avgMinutes = avgMinutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
}


class UserHistory: Object, ObjectKeyIdentifiable  {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var userID: ObjectId = ObjectId.generate()
    @Persisted var kcal: Float = 0.0
    @Persisted var cookDate: Date
    @Persisted var cookMinutes: Float = 0.0
    @Persisted var pastaPoint: Float = 0.0
    @Persisted var ratings: Float = 0.0
    @Persisted var count: Int = 0
    @Persisted var isCountable: Bool = true
    
    // 1.1.0 추가
    @Persisted var pastaBrand: String = ""              // 파스타 브랜드
    @Persisted var memo: String = ""                    // 히스토리별 메모
    
    convenience init(userID: ObjectId, kcal: Float, cookDate: Date, pastaPoint: Float) {
        self.init()
        self.userID = userID
        self.kcal = kcal
        self.cookDate = cookDate
        self.pastaPoint = pastaPoint
        
    }
}

// UserDefaults적용

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// 사용 예
struct Settings {
    
    // userDefaults에는 저장할 수 있는 데이터 타입이 정해져있음.
    // userDefaults에는 ObjectID타입의 데이터 타입은 저장할 수 없으므로 유의.

    @UserDefault(key: "_id", defaultValue: "\(ObjectId.generate())") // 각 User별 Data
    static var _id: String
    
    @UserDefault(key: "historyID", defaultValue: "") // 각 History별 Data
    static var historyID: String
    
    @UserDefault(key: "newHistoryID", defaultValue: "") // 각 History별 Data
    static var newHistoryID: String
    
    @UserDefault(key: "completeId", defaultValue: "") // 각 History별 Data
    static var completeId: String
    
    @UserDefault(key: "userEmoji", defaultValue: "🐈")
    static var userEmoji: String
    
    @UserDefault(key: "userName", defaultValue: "Anonymous")
    static var userName: String
    
    @UserDefault(key: "userPastaPoint", defaultValue: 1)
    static var userPastaPoint: Float
    
    @UserDefault(key: "userCalories", defaultValue: 200)
    static var userCalories: Float
    
    @UserDefault(key: "userRatings", defaultValue: 0)
    static var userRatings: Float
    
    @UserDefault(key: "userMinutes", defaultValue: 8)
    static var userMinutes: Float
    
    @UserDefault(key: "homeViewOption", defaultValue: "Average")
    static var homeViewOption: String
    
    @UserDefault(key: "historyViewOption", defaultValue: "Fold")
    static var historyViewOption: String
    
    @UserDefault(key: "portionViewOption", defaultValue: false)
    static var portionViewOption: Bool
    
    @UserDefault(key: "isDeletedHistory", defaultValue: false)
    static var isDeletedHistory: Bool
    
    @UserDefault(key: "inactiveTime", defaultValue: Date())
    static var inactiveTime: Date
    
    @UserDefault(key: "activeTime", defaultValue: Date())
    static var activeTime: Date
    
    @UserDefault(key: "backgroundTime", defaultValue: Date())
    static var backgroundTime: Date
    
    @UserDefault(key: "deactivateAllViews", defaultValue: false)
    static var deactivateAllViews: Bool
    
    @UserDefault(key: "fromHome", defaultValue: false)
    static var fromHome: Bool
    
    @UserDefault(key: "fromHistory", defaultValue: false)
    static var fromHistory: Bool
    
    @UserDefault(key: "mostHistory", defaultValue: "")
    static var mostHistory: String
    
    @UserDefault(key: "ratingHistory", defaultValue: "")
    static var ratingHistory: String
    
    @UserDefault(key: "isRatingButtonTapped", defaultValue: false)
    static var isRatingButtonTapped: Bool
    
    @UserDefault(key: "premiumAccess", defaultValue: false)
    static var premiumAccess: Bool
    
    @UserDefault(key: "firstMeet", defaultValue: true)
    static var firstMeet: Bool
    
    @UserDefault(key: "firstLogin", defaultValue: true)
    static var firstLogin: Bool
    
    // v.1.3.0 추가
    @UserDefault(key: "appReviewCount", defaultValue: 0)
    static var appReviewCount: Int
  
    
}

func makeRound(_ number : Float) -> Float{
    
    return round(number * 100) / 100
    
}



//어디서든지 아래와 같이 호출하여 사용 가능
//Settings.userAge = 25 // UserDefaults에 저장
//print(Settings.userAge) // UserDefaults에서 불러오기

// UserDefaults적용
