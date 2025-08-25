//
//  PPPBrain.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/08/05.
//

import Foundation
import CoreData
import AudioToolbox
import UserNotifications
import UIKit
import Combine
import RealmSwift
import SwiftUI
import AVFoundation
import StoreKit

// 아이폰 지원관련
func oldPhoneSupport() -> Bool{
    if String(UIDevice.current.name).contains("iPhone SE"){
        return false
    }else{
        return true
    }
}

// 사운드 재생
class Play {
    var audioPlayer: AVAudioPlayer?

    func sound(name: String, type: String) {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        } else {
            print("ERROR: Sound file not found")
        }
    }
}
// 데이터 리프레시(데이터 초기화)
func dataRefresh(){
    Settings.historyID = ""
    Settings.userMinutes = 8
    Settings.userRatings = 0
    Settings.userCalories = 200
    Settings.userPastaPoint = 1
    Settings.historyID = ""
    Settings.newHistoryID = ""
}


// 햅틱피드백

func hapticFeedBack(){
    
    let impactMed = UIImpactFeedbackGenerator(style: .rigid)
    impactMed.impactOccurred()
    
}
// 화면 로더
class DataLoader: ObservableObject {
    @Published var isLoading = true
    
    init() {
        loadData()
    }
    
    func loadData() {
        // 실제 데이터 로드를 시뮬레이트합니다. 여기서는 3초 후에 로딩이 완료되도록 합니다.
        DispatchQueue.global().async {
            // 실제 네트워크 요청이나 데이터 로드를 여기에 추가합니다.
            sleep(3)
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

//시간관련 전역함수
func timeFormatted(_ totalSeconds: TimeInterval) -> String {
    let minutes: Int = Int(totalSeconds / 60)
    let seconds: Int = Int(totalSeconds) % 60

    return String(format: "%d:%02d", minutes, seconds)
}


func resetSegmentedControlStyle() {
    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.mainRed)
    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.mainRed)], for: .normal)
    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.mainRed)], for: .normal)
    UISegmentedControl.appearance().backgroundColor = UIColor.clear
    
    UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .highlighted)
    UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .normal)
}



class NotificationManager {
    static let instance = NotificationManager()
    let content = UNMutableNotificationContent()
    
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(seconds: Float, title: String, body: String) {
        
       
    
        let doubledSeconds = Double(seconds)
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.defaultRingtone
        content.badge = NSNumber(value: currentBadgeNumber + 1)

        

        let identifier = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: doubledSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
        
    }
    
    func cancelAllNotifications() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 예약된 모든 알림을 취소
            UNUserNotificationCenter.current().removeAllDeliveredNotifications() // 이미 전달된 모든 알림을 제거
           
        }
    
    
    // userDefaults에 리스트 넣고, 넣을 때 마다 뱃지 추가시키고 하면 되겠네?

}

class Calculate {
    
    var realm = try! Realm()
    
    var userHistory : Results<UserHistory>
    var userHistoryById : Results<UserHistory>
    
    var userProfile : Results<UserProfile>
    var userProfileById : Results<UserProfile>
    
    init(){
 
        
        userHistory = realm.objects(UserHistory.self)
        
        userHistoryById = userHistory.where{
            try! $0.userID == ObjectId(string: Settings._id)
        }

        
        userProfile = realm.objects(UserProfile.self)
        userProfileById = userProfile.where{
            try! $0._id == ObjectId(string: Settings._id)
        }
        
        
    }
    
    
    func loadCustomData(search: String) -> Float{
        
        var value : Float = 0

        switch search{
            
        case "pastaPoint" :
            value = userProfileById[0].customPastaPoint
            if value == 0 {
                value = 1
            }
            return value
        case "minutes" :
            value = userProfileById[0].customMinutes
            if value == 0 {
                value = 8
            }
            return value
            
        default:
            return value
            
        }

    }
    
    func saveCustomData(pastaPoint: Float, miuntes: Float, calories: Float){
      
        let thawUserProfileById = userProfileById.thaw()!
        try! realm.write{
            
            thawUserProfileById[0].customCal = calories
            thawUserProfileById[0].customMinutes = miuntes
            thawUserProfileById[0].customPastaPoint = pastaPoint
        }
    
    }
    
    func saveCustomPastaPoint(pastaPoint: Float, calories: Float){
      
        let thawUserProfileById = userProfileById.thaw()!
        try! realm.write{
            
            thawUserProfileById[0].customCal = calories
            thawUserProfileById[0].customPastaPoint = pastaPoint
        }
    
    }
    
    func saveCustomMinutes( miuntes: Float){
      
        let thawUserProfileById = userProfileById.thaw()!
        try! realm.write{
            thawUserProfileById[0].customMinutes = miuntes
        }
    
    }
    
    
    func recentFiveHistories(search: String) -> Slice<Results<UserHistory>> {
        
        let value = userHistoryById.sorted(byKeyPath: search, ascending: false).prefix(5)
        
        return value
    }
    
    
    func most(search: String) -> UserHistory {
        
        if userHistoryById.isEmpty {
            print("Error!")
            
            return UserHistory() // 기본인스턴스 반환
          
        }else{
            let value = userHistoryById.sorted(byKeyPath: search, ascending: false).first!
            return value
        }

    }
    
    func average(search: String)  -> Float{
        
        let userHistoryByIdByisCountable = userHistoryById.where{
            
            $0.isCountable == true
            
        }
        
        if let value : Float = userHistoryByIdByisCountable.average(ofProperty: search) {
            
            return value
            
        } else {
            return 0
        }

    }
    
    func averageFiveHistories() -> [Float] {

        var values : [UserHistory] = []
        let valuesByDate = userHistoryById.sorted(byKeyPath: "cookDate", ascending: false)
        
        var range : Range<Int>{
            if valuesByDate.count <= 5{
                return 0..<valuesByDate.count
            }else{
                return 0..<5
            }
        }
        
        if !valuesByDate.isEmpty{
            for index in range{
                if valuesByDate[index].isCountable == true{
                    values.append(valuesByDate[index])
                }
            }
        }
        
        var pastaPoint : [Float] = []
        var pastaPointAverage : Float = 0
        
        var cookMinutes : [Float] = []
        var cookMinutesAverage : Float = 0
        
        
        for value in values{
            pastaPoint.append(value.pastaPoint)
            cookMinutes.append(value.cookMinutes)
        }
        
        pastaPointAverage = pastaPoint.reduce(0, +) / Float(pastaPoint.count)
        cookMinutesAverage = cookMinutes.reduce(0, +) / Float(cookMinutes.count)
        
        return values.isEmpty ? [0,0] : [pastaPointAverage,cookMinutesAverage]
    }
    
    

    
}




// 평균만드는 함수
func makeAverage(realmTable : Results<UserHistory>, column: String) -> Float {
    
    if let average : Float = realmTable.average(ofProperty: column) {
        
        return(average)

    } else {
        print("No scores to calculate an average")
        return 0
    }
    
}

//시간날짜 계산기

func daysAgo(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let startOfNow = calendar.startOfDay(for: now)
    let startOfDate = calendar.startOfDay(for: date)
    let components = calendar.dateComponents([.day, .second], from: startOfDate, to: startOfNow)
    let dayCount = components.day!
    
    switch dayCount {
    case 0:
        return "Today"
    case 1:
        return "1 Day Ago"
    default:
        return "\(dayCount) Days Ago"
    }
}




struct MakeRandomName {
    
    
    
    var name : String = ""
    
    let modifierList = [
        "Happy", "Sleepy", "Cheerful", "Energetic", "Playful",
        "Clever", "Gentle", "Graceful", "Adventurous", "Brave",
        "Silly", "Creative", "Curious", "Friendly", "Kind",
        "Lively", "Charming", "Chatty", "Calm", "Confident",
        "Eager", "Funny", "Helpful", "Honest", "Joyful",
        "Loving", "Optimistic", "Polite", "Quiet", "Relaxed",
        "Smart", "Thoughtful", "Trustworthy", "Warm", "Witty",
        "Adorable", "Cuddly", "Glamorous", "Gorgeous", "Handsome",
        "Radiant", "Stunning", "Bouncy", "Fierce", "Vibrant",
        "Zealous", "Enthusiastic", "Elegant", "Glamorous", "Majestic",
        "Noble", "Resplendent", "Regal", "Mellow", "Soothing",
        "Tranquil", "Serene", "Peaceful", "Humble", "Modest",
        "Innocent", "Sincere", "Genuine", "Original", "Authentic",
        "Quirky", "Whimsical", "Eccentric", "Vivacious", "Dynamic",
        "Radiant", "Dazzling", "Stunning", "Effervescent", "Sparkling",
        "Bubbly", "Creative", "Inventive", "Inspiring", "Motivated",
        "Resourceful", "Ambitious", "Passionate", "Resilient", "Brilliant",
        "Intelligent", "Witty", "Sharp", "Clever", "Insightful",
        "Brave", "Fearless", "Bold", "Daring", "Courageous",
        "Adventurous", "Curious", "Explorer", "Trailblazer", "Pioneer",
        "Strong", "Powerful", "Mighty", "Robust", "Vigorous"
    ]
    
    let emojiDict: [String: String] = [
        "Dog": "🐶",
        "Cat": "🐱",
        "Mouse": "🐭",
        "Hamster": "🐹",
        "Rabbit": "🐰",
        "Fox": "🦊",
        "Bear": "🐻",
        "Panda": "🐼",
        "Koala": "🐨",
        "Tiger": "🐯",
        "Lion": "🦁",
        "Cow": "🐮",
        "Pig": "🐷",
        "Frog": "🐸",
        "Monkey": "🐵",
        "Chicken": "🐔",
        "Penguin": "🐧",
        "Unicorn": "🦄"
    ]
    
    

    
    
    
    func make() -> String{
        
        let modifier = self.modifierList.randomElement() ?? ""
        let emojiKey = Array(self.emojiDict.keys).randomElement() ?? ""
        
        
        return ("\(modifier) \(emojiKey)")
        
    }
    
    func findEmoji(name: String)->String{
        
        
        for emoji in self.emojiDict.keys{
            
            if name.contains(emoji) {
                return (self.emojiDict[emoji] ?? "")
            }
            
        }
        return ("🍝")
        
        
    }
    
    
}


func checkAlDante(num : Int) -> String{
    
    if num == 1 {
        return("Al Dante")
    } else if num == 2 {
        return("Cottura")
    } else {
        return("Ben Cotto")
    }
}







class SharedData: ObservableObject {
    
    @Published var currentDoneness : String = ""
    @Published var currentTime : Double?
    @Published var minValue : Double = 0.0
    @Published var maxValue : Double = 20.0
    @Published var valueGap : Double = 0.0
    @Published var seconds : Int = 0
    
    @Published var ratings : Int = 0
    
    
    func updateRange(doneness: String){
        
        
        
        if doneness == "Al Dente" {
            minValue = 6.0
            maxValue = 10.0
            
        } else if doneness == "Cottura" {
            minValue = 10.0
            maxValue = 15.0
            
            
        } else if doneness == "Ben Cotto" {
            minValue = 16.0
            maxValue = 20.0
            
            
        }else{
            minValue = 6.0
            maxValue = 20.0
            
        }
        
        valueGap = maxValue - minValue
        currentTime = (minValue + maxValue) / 2
        seconds = Int(currentTime ?? 0) * 60
        
    }
    
    func updateCurrentTime(seconds: Int) {
        self.currentTime = Double(seconds / 60)
    }
    
}






//스크린 사이즈 로드
class DeviceScreenSizeViewModel: ObservableObject {
    
    // 1파스타 포인트의 원면적은 2cm임 인치로는 7/8임.

    func fetchPPI() -> Int?{
        let currentDevice: String = String(UIDevice.current.name)
        let iphonePPI: [String: Int] = [
            "iPhone 16 Pro Max": 460,
            "iPhone 16 Pro": 460,
            "iPhone 16 Plus": 460,
            "iPhone 16": 460,
            "iPhone 15 Pro Max": 460,
            "iPhone 15 Pro": 460,
            "iPhone 15 Plus": 460,
            "iPhone 15": 460,
            "iPhone 14 Plus": 458,
            "iPhone 14 Pro Max": 460,
            "iPhone 14 Pro": 460,
            "iPhone 14": 460,
            "iPhone SE 3rd gen": 326,
            "iPhone 13": 460,
            "iPhone 13 mini": 476,
            "iPhone 13 Pro Max": 458,
            "iPhone 13 Pro": 460,
            "iPhone 12": 460,
            "iPhone 12 mini": 476,
            "iPhone 12 Pro Max": 458,
            "iPhone 12 Pro": 460,
            "iPhone SE (3rd generation)": 326,
            "iPhone 11 Pro Max": 458,
            "iPhone 11 Pro": 458,
            "iPhone 11": 326,
            "iPhone XR": 326,
            "iPhone XS Max": 458,
            "iPhone XS": 458,
            "iPhone X": 458,
            "iPhone 8 Plus": 401,
            "iPhone 8": 326,
            "iPhone 7 Plus": 401,
            "iPhone 7": 326,
            "iPhone SE (2nd generation)": 326,
            "iPhone 6s Plus": 401,
            "iPhone 6s": 326,
            "iPhone 6 Plus": 401,
            "iPhone 6": 326,
            "iPhone 5C": 326,
            "iPhone 5S": 326,
            "iPhone 5": 326,
            "iPhone 4S": 326,
            "iPhone 4": 326,
            "iPhone 3GS": 163,
            "iPhone 3G": 163,
            "iPhone SE (1st generation)": 163
        ]
        
        return iphonePPI[currentDevice] ?? 460
        
    }
    
    
    func calculateSize(forWidth widthPixels: Int, andHeight heightPixels: Int, withPPI ppi: Int) -> (widthCm: Double, heightCm: Double) {
        let widthCm = floor(Double(widthPixels) / Double(ppi) * 2.54 * 100) / 100
        let heightCm = floor(Double(heightPixels) / Double(ppi) * 2.54 * 100) / 100
        
        return (widthCm, heightCm)
    }
    
    
    //화면 포인트를 파스타포인트로 전환
    func pastaPoint(circleSize : CGFloat, scale : CGFloat, standardPastaPoint : CGFloat, ppi : Int) -> CGFloat{
        let realCircleSize = circleSize*scale/CGFloat(ppi)
        let point = pow((realCircleSize / 2), 2) / pow(standardPastaPoint / 2,2)
        return point
    }
    
    
    //파스타포인트를 화면내부 포인트로 전환
    func reversePastaPoint(circleSize : CGFloat, scale : CGFloat, standardPastaPoint : CGFloat, ppi : Int, pastaPoint : CGFloat) -> CGFloat{
        let reversedPoint = sqrt(Double(pastaPoint * pow(standardPastaPoint / 2,2))) * 2
        let reversedCircleSize = CGFloat(reversedPoint) * CGFloat(ppi) / scale
        return reversedCircleSize
    }
    
    

}


// 앱리뷰
struct AppReviewRequest {
    static func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    static func openAppStoreReview() {
        let appId: String = "6670216246"
        let urlStr = "https://itunes.apple.com/app/id\(appId)?action=write-review"
        guard let url = URL(string: urlStr) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
