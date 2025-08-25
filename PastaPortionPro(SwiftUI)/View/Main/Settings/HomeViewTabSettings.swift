//
//  HomeViewTabSettings.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct HomeViewTabSettings: View {
    
    //각메뉴별 세팅가능
    //현재 사용자 인포
    //로컬사용자 삭제기능(삭제, 잠금-잠금을 풀어야 삭제가능)
    
    @Binding var selectedTab : String
    
    @State private var avgPastaPoint : Float = 1
    @State private var avgCalories : Float = 200
    @State private var avgMinutes : Float = 8
    
    @State private var notificationsEnabled : Bool = true
    
    @State private var showAlert : Bool = false
    
    @State private var showAlertProfile : Bool = false
    @State private var showAlertADs : Bool = false
    @State private var showAlertRestore : Bool = false
    @State private var showAlertClearHistory : Bool = false
    
    @EnvironmentObject var presentData : PresentData
    
    // 인앱구매
    @ObservedObject var purchaseManager = InAppPurchaseManager()
    @AppStorage("premiumAccess") private var premiumAccess: Bool = false

    let calculate = Calculate()

    var body: some View {
        
        NavigationView {
            
            
            Form {
                HStack{
                    
                    Spacer()

                    RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                        .frame(width: 300, height: 275)
                        .foregroundColor(.white)
                        .shadow(color: premiumAccess ? .mainRed.opacity(0.7) : .black.opacity(0.6), radius: 3) // 프리미엄 액세스
                        .onAppear(perform: {
                            premiumAccess = Settings.premiumAccess
                        })
                        .overlay{
                            ZStack{
                                
                                if premiumAccess{ // 프리미엄 액세스
                               
                                Rectangle()
                                    .overlay{
                                        HStack{
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(.white)
                                             
                                            Text("Premium Access")
                                                .bold()
                                                .foregroundColor(.white)
                                         
                                        }
                                        .font(.system(size: 12))
                                        .padding()
                                        
                                    }
                                    .clipShape(CustomCornerShape(cornerRadius: 5, corners: [.bottomLeft, .bottomRight]))
                                    .foregroundColor(.mainRed)
                                    .offset(CGSize(width: 0.0, height: -127.5))
                                    .frame(width: 154, height: 20)
                                    .shadow(radius: 4)
                                    
                                } // if Settings.premiumAccess == true
                                
                                VStack{
                                    
                                    ZStack{
                                        
                                        Circle()
                                            .frame(width: 165)
                                            .foregroundColor(.white)
                                            .shadow(radius: 3)
                                        
                                        Circle()
                                            .frame(width: 150)
                                            .shadow(radius: 3)
                                            .foregroundColor(.white)
                                            .overlay{
                                                Text(Settings.userEmoji)
                                                    .font(.system(size: 110))
                                                    .shadow(radius: 1)
                                                    
                                            }
                                            
                                    } // ZStack
                                  
                                    
                                    
                                    HStack{
                                    
                                        Text("\(Settings.userName)")
                                            .font(.system(size: 20))
                                            .bold()
                                    } // HStack
                                    
                                    
                                    
                                    Divider()
                                        .frame(width: 200)
                                        .padding(.top, -3)
                                    
                                    HStack{
                                        
                                        Text("\(avgPastaPoint, specifier: "%.2f") pt")
                                        Text("|")
                                            .foregroundColor(.gray)
                                            .opacity(0.5)
                                        Text("\(avgCalories, specifier: "%.0f") cal")
                                        Text("|")
                                            .foregroundColor(.gray)
                                            .opacity(0.5)
                                        
                                        Text("\(avgMinutes, specifier: "%.1f") m")
                                        
                                    }
                                    .font(.system(size: 18))
                                    .bold()
                                    
                                    // 1.0.2 업데이트 --->
                                    .onAppear(perform: {
                                   
                                        // 세팅 프로필에서 바로 반영 안됨 - 수정할것. 1.0.3쯤에서나?
                                        // 앱추적금지 요청 처리할것 : 프리미엄 기능 신청한 상황에서도 추적함.
                                        if premiumAccess{
                                            let calculate = Calculate()
                                            avgPastaPoint = calculate.average(search: "pastaPoint")
                                            avgCalories = calculate.average(search: "kcal")
                                            avgMinutes = calculate.average(search: "cookMinutes")
                                        }else{
                                            avgPastaPoint = calculate.averageFiveHistories()[0]
                                            avgMinutes = calculate.averageFiveHistories()[1]
                                            avgCalories = avgPastaPoint * 200
                                        }
                                        
                                    })
                                    // <--- 1.0.2 업데이트

                                    // HStack

                                
                            } // VSTack
                            }
                            
                   
                        
                    }
                    
                    Spacer()
                    
                }
                .listRowBackground(Color.clear)

                
                
           
                
                Section(header: Text("Profile")) {

                    
                    Button(action: {
                        
                        showAlertProfile = true
                        
                     
                        
                    }) {
                        HStack{
                            InAppIcon(iconName: "person.fill.and.arrow.left.and.arrow.right", iconColor: .mainRed, backgroundColor: .white)
                                .padding(.trailing)
                                .shadow(radius: 1)
                            
                            Text("Log Out to Change Profile")
                                .foregroundColor(.black)
                        }
                        
                    }
                    .alert("Are You Sure?", isPresented: $showAlertProfile){
                        
                        Button("Yes"){
                            
                            // 로그아웃한 날짜 업데에트
                            let calculate = Calculate()
                            let realm = calculate.realm
                            try! realm.write{
                                calculate.userProfileById.first?.updatedAt = Date()
                            }
                            
                            // 관련 데이터 초기화
                            dataRefresh() // PPPBrain
                            
                            // nil처리에 대한 이해가 있기 전까지 건드리지 말것
                            presentData.currentView = "LogIn"
        
                            
                        }
                        .foregroundColor(.mainRed)
                        
                        Button("No", role: .cancel){
                            
                            showAlertProfile = false
                            
                        }
                        
                    }
                    
                } // Profile끝
                
                Section(header: Text("Help")) {
                    NavigationLink(destination: Welcome()){
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                                    .frame(width: 30, height: 30)
                                    
                                    .overlay{
//                                        Text("?")
                                        Image(systemName: "questionmark")
                                            .bold()
                                            .foregroundColor(.mainRed)
                                    }
                                
                            }
                            
                            Text("How to Use the App")
                                .bold()
                                .padding(.horizontal)
                                .foregroundColor(.black)
                        }
                        
                    }
                }
                
                Section(header: Text("purchase")) {
    
                    Button(action: {
                        if !premiumAccess {
                            showAlertADs = true
                        }
                        
                        
                    }) {
                        HStack{
                            if premiumAccess {
                                
                                
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .foregroundColor(.white)
                                    .shadow(color: .mainRed, radius: 1)
                                    .frame(width: 30, height: 30)
                                
                                    .overlay{
                                        Image(systemName: "checkmark.seal.fill")
                                            .bold()
                                            .foregroundColor(.mainRed)
                                    }
                                
                                
                                
                            }else{
                                ZStack{
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .foregroundColor(.white)
                                        .shadow(radius: 1)
                                        .frame(width: 30, height: 30)
                                    
                                        .overlay{
                                            Text("AD")
                                                .bold()
                                                .foregroundColor(.mainRed)
                                        }
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.mainRed)
                                        .font(.system(size: 12))
                                        .offset(CGSize(width: 14.0, height: 11.0))
                                    

                                }
                             
                               
                            }
                            
                            Text(premiumAccess ? "Using Premium Access" : "Get Premium Access" )
                                .foregroundColor(.mainRed)
                                .bold()
                                .padding(.horizontal)
                        }
                        
                    }
                    
                    .sheet(isPresented: $showAlertADs) { // Moved sheet here
                        InAppPurchase()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                    
                    Button(action: {
                        
                        showAlertRestore = true
                        
                    }) {
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                                    .frame(width: 30, height: 30)
                                    
                                    .overlay{
                                        Text("Re")
                                            .bold()
                                            .foregroundColor(.black)
                                    }
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 12))
                                    .offset(CGSize(width: 14.0, height: 11.0))

                            }
                            
                            Text("Restore Purchase")
                                .bold()
                                .padding(.horizontal)
                                .foregroundColor(.black)
                        }
                            
                    }
                    .onAppear {
                        purchaseManager.fetchProducts(identifiers: ["im.studio5.pastaportionpro.remove_ads"])
                          }
                    .alert("Restore Purchase", isPresented: $showAlertRestore){
                        
                        Button("Yes"){
                
                            purchaseManager.restorePurchases()
                            
                        }
                        .foregroundColor(.mainRed)
                        
                        
                        
                        Button("No", role: .cancel){
                            
                            showAlertRestore = false
                            
                        }
                        
                    }
                    
                } // PURCHASE Section
            
              
                Section(header: Text("User Data")) {
                    
                    let calculate = Calculate()
                    
                    
                    if calculate.userHistoryById.isEmpty{
                        
                        Button(action: {
                            
                            showAlertClearHistory = true
                            
                        }, label: {
                            HStack{
                                InAppIcon(iconName: "nosign", iconColor: .mainRed, backgroundColor: .white)
                                    .padding(.trailing)
                                    .shadow(radius: 1)
                                Text("There Is No Data")
                                    .foregroundColor(.black.opacity(0.6))
                                    .bold()
                            }
                            
                        })
//                        .alert("There Is No Data!", isPresented: $showAlertClearHistory){
//                            Button("No", role: .cancel){
//                                
//                                showAlertClearHistory = false
//                            }
//                        }
                        
                    }else{
                        
                        
                        Button(action: {
                            
                            showAlertClearHistory = true
                            
                        }, label: {
                            HStack{
                                InAppIcon(iconName: "eraser.fill", iconColor: .black.opacity(0.4), backgroundColor: .white)
                                    .padding(.trailing)
                                    .shadow(radius: 1)
                                Text("Clear All History")
                                    .foregroundColor(.black.opacity(0.6))
                                    .bold()
                            }
                        })
                        .alert("Are You Sure to Clear All Data?", isPresented: $showAlertClearHistory){
                            
                            Button("Yes"){

                                do {
                                    let realm = try Realm()
                                    
                                    // 필터 조건에 맞는 객체들을 조회합니다.
                                    let calculate = Calculate()
                                    
                                    
                                        
                                        print(Settings._id)
                                        // 삭제 작업을 트랜잭션 내에서 수행합니다.
                                        try realm.write {
                                            realm.delete(Array(calculate.userHistoryById))
                                            realm.delete(Array(calculate.recentFiveHistories(search: "cookDate")))
                                        }
                                        print("All user histories have been deleted.")


                                   
                                    
                                } catch let error as NSError {
                                    print("Error deleting user Histories: \(error.localizedDescription)")
                                }
                                
                            }
                            .foregroundColor(.mainRed)
                            
                            Button("No", role: .cancel){
                                
                                showAlertClearHistory = false
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                Section(header: Text("ABOUT")) {
                    
                    NavigationLink(destination: About()) {
                        HStack{
                            
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                                    .frame(width: 30, height: 30)
                                    
                                    .overlay{
                                        Image("PPP_LOGO")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .clipped()
                                    }
                               
                            Text("About Pasta Portion Pro")
                
                                .padding(.horizontal)
                                
                        }
                    }
                    .foregroundColor(.black)
                    
                }
                
                
            }

            
            
        }
        .tint(.mainRed) // 네비게이션 백버튼 색상
        
        // 1.0.2 업데이트 --->
        .onAppear{
            
            // free user 평균값 계산
            averageForFreeUser()
        }
        .onChange(of: premiumAccess, perform: { value in
            averageForFreeUser()
        })
        //  <--- 1.0.2 업데이트
    }
    
    func averageForFreeUser(){
        
        let calculate = Calculate()
        let realm = calculate.realm
        
        if !Settings.premiumAccess{
            let averagePastaPoint = calculate.averageFiveHistories()[0]
            let averageMinute = calculate.averageFiveHistories()[1]
            let averageKcal = averagePastaPoint * 200
            
            
            try! realm.write{
                calculate.userProfileById.first?.avgPastaPoint = averagePastaPoint
                calculate.userProfileById.first?.avgCal = averageKcal
                calculate.userProfileById.first?.avgMinutes = averageMinute
            }
            
        }else{
            
            // 1.0.2 추가 --->
            
            
            let averagePastaPoint = calculate.average(search: "pastaPoint")
            let averageMinute = calculate.average(search: "cookMinutes")
            let averageKcal = calculate.average(search: "kcal")
            
            try! realm.write{
                calculate.userProfileById.thaw()!.first?.avgPastaPoint = averagePastaPoint
                calculate.userProfileById.thaw()!.first?.avgCal = averageKcal
                calculate.userProfileById.thaw()!.first?.avgMinutes = averageMinute
            }
            
            // <--- 1.0.2 추가
            
        }
    }
    
}

struct HomeViewTabSettings_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewTabSettings(selectedTab: .constant("Settings"))
        
        
            .environmentObject(PresentData())
    }
}

struct SettingsButton: View {
    
    @Binding var showAlert : Bool
    @State var text : String = ""
    @State var textColor : Color = .clear
    @State var alertMessage : String = ""
    @State var iconName : String
    @State var iconColor : Color
    @State var iconBackgroundColor : Color
    
    
    init(showAlert: Binding<Bool>, text: String, textColor: Color, alertMessage: String, iconName: String, iconColor: Color, iconBackgroundColor: Color) {
        
        self._showAlert = showAlert
        
        
        self.text = text
        self.textColor = textColor
        self.alertMessage = alertMessage
        self.iconName = iconName
        self.iconColor = iconColor
        self.iconBackgroundColor = iconBackgroundColor
    }
    
    var body: some View {
        
        Button(action: {
            
            showAlert = true
            
        }) {
            
            HStack{
                
                Rectangle()
                    .fill(iconBackgroundColor)
                    .frame(width: 28, height: 28)
                    .cornerRadius(5)
                    .overlay{
                        Image(systemName: iconName)
                            .bold()
                            .foregroundColor(iconColor)
                    }
                    .padding(.trailing)
                
                Text(text)
                    .foregroundColor(textColor)
            }
            
                
        }
        .alert(alertMessage, isPresented: $showAlert){
            
            Button("Yes"){
                
                
            }
            .foregroundColor(.mainRed)
            
            Button("No", role: .cancel){
                
                showAlert = false
                
            }
            
        }
        
    }
}


struct CustomCornerShape: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}
