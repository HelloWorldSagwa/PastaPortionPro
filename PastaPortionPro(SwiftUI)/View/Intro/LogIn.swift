//
//  NewIntro.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 1/7/24.
//

import SwiftUI
import RealmSwift
import AdSupport
import AppTrackingTransparency      // 광고 트래킹권한 요청
import FirebaseCore                 // Firebase 추가 - v1.1.0
import FirebaseAnalytics


// 2024/02/21 - 렐름 적용 및 코어데이터 삭제
// 2024/04/03 - UserDefaults 적용
// 2024/05/24 - delete 다시 코드 짜고 웰컴화면 추가할것


struct LogIn: View {
    

    @State private var newUserName : String = MakeRandomName().make()
    var makeRandomName = MakeRandomName()
    @State private var newUserEmoji : String = "🐈"
    @State private var newUserNameCount : Int = 26
    @State private var isInputValid: Bool = false
    
    // 처음 로그인한 사용자인지 여부
    @State private var isUserDataEmpty : Bool = false
    
    // 현재 로그인 상태
    @EnvironmentObject var presentData : PresentData
    
    // 내부 DB 저장
    let realm = try! Realm()
    
    @ObservedResults(UserProfile.self) var userProfile
    
    // 정식릴리즈 여부
    @State var isReleaseCandidate : Bool = true
    
    
    // 무료사용자 제한
    var currentUserCount : Int {
        let calculate = Calculate()
        print("the Count is??????",calculate.userProfile.count)
        
        return calculate.userProfile.count
    }
    
    @State var freeUserCountLimit : Int = 2
    @State var showPurchaseSheet : Bool = false
//    @State var isLimitReached : Bool = false
    @AppStorage("premiumAccess") private var premiumAccess: Bool = false
    @AppStorage("isLimitReached") private var isLimitReached: Bool = false
    
    
    var body: some View {
        
    
        VStack(){
            
            Spacer()
            MainLogoInSlogan(size: 350)
            
                

            if !isReleaseCandidate{
                
              TestMode()
                
            } // 테스트모드
            

            
            
            VStack(spacing: -20){
                
                VStack{
                    
  
                    VStack {
                        
                        
                        Group{
                            
                            HStack{
                                
                                TextField("", text: $newUserName)
                                
                                    .onChange(of: newUserName) { newValue in
                                        
                                        print("newUserName: \(newUserName)")
                                        
                                        newUserName = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                        
                                        if newValue.count > newUserNameCount{
                                            newUserName = String(newValue.prefix(newUserNameCount))
                                        }
                                        
                                    } //리얼타임으로 앞뒤공백제거
                                    .font(.system(size:20))
                                    .padding(.bottom ,5)
                                
                                Button(action: {
                                    
                                    newUserName = makeRandomName.make()
                                    newUserEmoji = makeRandomName.findEmoji(name: newUserName)
                                    
                                    if currentUserCount >= freeUserCountLimit{
                                        isLimitReached = true
                                    }else{
                                        isLimitReached = false
                                    }
                                    
                                    
                                }) {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .foregroundColor(.black)
                                }
                                
                            }
                       
                        
                        // TextField 실선
                        Rectangle()
                            .frame(height: 1) // 밑줄의 높이
                            .foregroundColor(.mainRed)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        
                        if  newUserName.count <= 4{
                            
                            Text("Your name must be 4+ characters")
                                .opacity(0.6)
                        }else{
                            
                            
                            // 오프라인 로그인
                            
                            Button(action: {
                                
                                if !premiumAccess && currentUserCount >= freeUserCountLimit {
                                    
                                    showPurchaseSheet = true
                                    
                                }else{
                                    
                                    
                                newUserEmoji = makeRandomName.findEmoji(name: newUserName)
                                
                                // 현재 로그인 관련 데이터
                                
                                presentData.currentView = "LoggedOn" // 뷰제어
                                
                                // UserDeafaults에 저장
                                
                                Settings.userName = newUserName
                                Settings.userEmoji = newUserEmoji
                                
                                print("UserDeafaults saved!\(Settings.userName)")
                                
                                // 내부 DB저장
                                
                                let userProfile = UserProfile(name: newUserName, emoji: newUserEmoji, avgCal: 200.0, avgPastaPoint: 1.00, avgRatings: 0.00, avgMinutes: 8.0, createdAt: Date(), updatedAt: Date())

                                $userProfile.append(userProfile)
                                
                              
                                // 이모지 출력
//                                
//                                print("/////user profile saved!!/////\n\(userProfile)")
                                
                                
                                // 현재 로그인데이터에 Realm에서 생성된 UUID(PK값) 저장
                                
                                Settings._id = userProfile._id.stringValue // ObjectID는 userDefaults에서 사용불가
                                
                                print("ObjectID : \(Settings._id)")

                                }
                                
                                
                            }, label: {
                                
                                if  !premiumAccess &&  isLimitReached {
                                    Text("Profile Creation Limit Exceeded")
                                        .minimumScaleFactor(0.5) // 텍스트 배율 조정
                                        .modifier(StyledButtonModifier())
                                }else{
//                                    Text("Create Profile")
                                    Text(LocalizedStringKey("Create Profile"))
                                        .modifier(StyledButtonModifier())
                                }
                                
                            })
                            
                            .onAppear(perform: {
                                
                            
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        //                    DispatchQueue.main.async {
                                    if #available(iOS 14, *) {
                                        ATTrackingManager.requestTrackingAuthorization { status in
                                            switch status {
                                            case .authorized:           // 허용됨
                                                print("Authorized")
                                                print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")
                                            case .denied:               // 거부됨
                                                print("Denied")
                                            case .notDetermined:        // 결정되지 않음
                                                print("Not Determined")
                                            case .restricted:           // 제한됨
                                                print("Restricted")
                                            @unknown default:           // 알려지지 않음
                                                print("Unknow")
                                            }
                                        }
                                    }
                                }
                            })
                            .onAppear(perform: {
                                isLimitReached = currentUserCount >= freeUserCountLimit
                            })
                            .onChange(of: currentUserCount, perform: { value in
                                isLimitReached = value >= freeUserCountLimit
                            })
                            .sheet(isPresented: $showPurchaseSheet) { // Moved sheet here
                                InAppPurchase()
                                    .presentationDetents([.large])
                                    .presentationDragIndicator(.visible)
                            }
                            
                        }
                        
                        
                    
                        
                        
                    }
                    .padding(.horizontal, 20)
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        Spacer()
            .frame(height: 30)
        
        Rectangle()
            .frame(height: 10)
            .foregroundColor(.gray)
            .opacity(0.2)
        
        
        UserList()
        
        
        
        // 예시 스택
        
    
        
        
    }
    
    
    
    private func validateInput(_ text: inout String) {
        // 최대 20자 제한
        if text.count > 20 {
            text = String(text.prefix(20))
        }
        
        // 앞뒤로 공백 제거
        text = text.trimmingCharacters(in: .whitespaces)
        
        // 중간에 하나 이상의 공백 허용하지 않음
        let components = text.split(separator: " ", omittingEmptySubsequences: false)
        if components.count > 2 {
            text = components.prefix(2).joined(separator: " ")
        }
    }
}





#Preview {
    LogIn()
        .environmentObject(PresentData())
}




struct MainLogo: View {
    
    @EnvironmentObject var presentData : PresentData
    
    var body: some View {
        

            Image("PPP_LOGO")
                .resizable()
                .scaledToFit()
                .frame(width: 330)  // 크기를 줄임
                .clipped()
    
    }
}





struct UserList :View {
    
    @EnvironmentObject var presentData : PresentData
    
    let realm = try! Realm()
    @ObservedResults(UserProfile.self) var userProfile
    @ObservedResults(UserHistory.self) var userHistory
    
   
    // 무료사용자 제한
    var currentUserCount : Int {
        let calculate = Calculate()
        print("the Count is??????",calculate.userProfile.count)
        
        return calculate.userProfile.count
    }

    @AppStorage("isLimitReached") private var isLimitReached: Bool = false
    
    // 이스터 에그
    let play = Play()
    
    var body: some View {
        
        VStack{
            
        }
     
        if realm.isEmpty {
           
            
            VStack{
                
                
                List{
                    
                    Section{
                        
                        HStack{
                            Spacer()
                            VStack(){
                                
                                Image("StudioCat_trans")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .clipped()
                                    .shadow(radius: 7)
                                    .onTapGesture {
                                        play.sound(name: "EasterEggCatSound", type: "mp3")
                                    }
                                Divider()
                                VStack(alignment: .center){
                                    
                                    Text("This app uses offline login.")
                                    Text("Easily set up your profile with just a tap!")
                                    
                                }
                                
                                Divider()
                                
                            }
                            Spacer()
                            
                        }
                        
                        
                        
                        
                    }
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
            
        } else {
            
            List{
                
                    ForEach(userProfile.sorted(byKeyPath: "updatedAt", ascending: false), id:\.self){ singleUserProfile in // id 설정필요
                    
                    Button(action: {
                        
                        // 해야할것
                        // (1) 저장된 프로파일 내부의 데이터 로드
                        // (2) 로드된 데이터를 userDefaults 에 뿌림
                        
                        Settings._id = singleUserProfile._id.stringValue
                        Settings.userName = singleUserProfile.name
                        Settings.userEmoji = singleUserProfile.emoji
                        Settings.userMinutes = 8
                        Settings.userRatings = 0
                        Settings.userCalories = 200
                        Settings.userPastaPoint = 1.0
                        
                        // (3) 화면 전환 -> 화면을 변경
                        presentData.currentView = "LoggedOn"
                        
                        // (4) 로그인 하자마자 updatedAt 최신으로변경 : 로그아웃할 때도 마찬가지임
                        let thawSingleUserProfile = singleUserProfile.thaw()
                        
                        try! realm.write{
                            thawSingleUserProfile?.updatedAt = Date()
                        }
            
                        
                    }, label: {
                        HStack{
                            
                            Text(singleUserProfile.emoji)
                                .font(.system(size: 40))
                                .shadow(radius: 10)
                            
                            VStack(alignment: .leading){
                                
                                HStack{
                                    
                                    Text(singleUserProfile.name)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Text("\(singleUserProfile.updatedAt, style: .date)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12))
                                    
                                }
                                
                                
                                HStack{
                                    Text("\(singleUserProfile.avgPastaPoint, specifier: "%.2f") pt")
                                        .bold()
                                        .foregroundColor(.mainRed)
                                    
                                    Text("|")
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                    Text("\(singleUserProfile.avgCal, specifier: "%.0f") cal")
                                        .font(.system(size: 17))
                                    Text("|")
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                    Text("\(singleUserProfile.avgMinutes, specifier: "%.1f") m")
                                    
                                }
                                .font(.system(size: 18))
                                
                            }
                            
                        }
                        .foregroundColor(.black)
                    })
                    .swipeActions {
                        
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            
                            
                            
                            
                            let userHistoryId = realm.objects(UserHistory.self).filter("userID == %@", singleUserProfile._id)
                            
                            let userProfileId = realm.objects(UserProfile.self).filter("_id == %@", singleUserProfile._id)
                            
                            try! realm.write{
                                
                                realm.delete(userHistoryId)
                                realm.delete(userProfileId)
                                
                                
                            }
                            
                            if currentUserCount >= 2{
                                isLimitReached = true
                            }else{
                                isLimitReached = false
                            }

                            
                        }
                    }
                    
                    
                }
                
                
            }
            .background(Color.mainGray)
            
            .scrollContentBackground(.hidden)
            
            
        }
        
    }
    

    
}

struct DeleteAllRealm: View {

    let realm = try! Realm()

    var body: some View {

        Button(action: {
            // ----- 렐름 삭제코드

            try! realm.write {
                realm.deleteAll()
            }

            // ----- 렐름 삭제코드
        }, label: {
            Text("Delete All Realm Data Base")
        })

        Button(action: {

            do {
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll() // 모든 데이터 삭제
                }
                let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
                try FileManager.default.removeItem(at: realmURL) // 파일 삭제
            } catch let error as NSError {
                print("Realm 삭제 오류: \(error)")
            }

        }, label: {
            Text("Delete All for Migration")
                .foregroundColor(.red)
                .bold()
        })
    }
}

struct IapTest: View {
    @Binding var iapButtonTapped : Bool
    
    var body: some View {
        Button(action: {
            iapButtonTapped = true
        }, label: {
            Text("InAppPurchaseTest")
        })
        .sheet(isPresented: $iapButtonTapped) { // Moved sheet here
            InAppPurchase()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct TestMode: View {
    
    // 인앱결재 테스트
    @State var iapButtonTapped : Bool = false
    
    var body: some View {
        // 렐름 에러캐치 //
        Text("This is a Test Version : 2024/06/21")
       
        DeleteAllRealm()
        IapTest(iapButtonTapped : $iapButtonTapped)
        Spacer()
    }
}
