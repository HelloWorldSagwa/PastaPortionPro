//
//  HomeViewTabHome.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/04.
//


//---------------홈뷰-홈(탭) 시작---------------//


import SwiftUI
import RealmSwift


// 디테일 수정내역
// 1. 원을 좀 더 깔끔하게 수정 - 처리
// 2. 써클 상하 비율 조정 - 처리

// 1. history .isEmpty일 때 구현 - 처리
// 2. history 횡한거 수정 - 처리
// 3. custom 모달 팝업 - 처리
// 4. settings에 temp값 만들기 - 따로 만들지 않고 기존에 있는 변수에 넣음 - 처리
// 5. nil값일 때 Most탭 선택시 버그 발생 - 수정
// 6. 버튼눌렀을 때 안물고 감 - 4와 연계 - 처리
// 7. 팝업창 떴을 때 기존 값 불러오기 - 처리
// 8. 최초화면에서 custom피커 바로 선택시 뷰가 전환되지 않음 -? 이유를 모르겠음.. 디테일 작업으로 넘김
// 9. Portion버튼 누르자마자 히스토리 쌓이게 할것 - 처리

struct HomeViewTabHome: View {
    
    
    
    @Binding var selectedTab : String
    
//    @State var portionWith : String = "Average"
    @State var portionWith : String = "Average"
    @State var historyId : String = "" // 히스토리 ID저장 : most, 5histories만 해당
    @State var selectedLink : String = "Average"
    
    //최초 바인딩값
    @State var pastaPoint : Float = 1
    @State var calories : Float = 200
    @State var minutes : Float = 8
    
    
    
    
    var body: some View {
        
  
        
        VStack{
            
            
            TopStack(selectedLink: $selectedLink)
            
            Divider()
                .padding(.bottom, 15)
            
            
            
            Group{
                HomeCircle(portionWith: $portionWith, pastaPoint: $pastaPoint, calories: $calories, minutes: $minutes, historyId: $historyId, selectedLink: $selectedLink)
                    .onAppear(perform: {
                        portionWith = Settings.homeViewOption
                    })
                
                VStack(spacing: 20){
                    ZStack{
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 130, height: 1)
                            .overlay{
                                Text("Recent 5 Histories")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .bold()
                            }
                            .zIndex(2)
                        
                        Divider()
                            .zIndex(1)
                        
                    }
                    
                    
                    HomeHistory(selectedTab: $selectedTab)
                       
                }
                
                
                MainButton(selectedTab: $selectedTab, portionWith: $portionWith, pastaPoint: $pastaPoint, calories: $calories, minutes: $minutes)
                
                
                //            admobBanner() // 2024.06.20 삭제
                
            }
            .padding(.horizontal, 20)
            
            
        }
        
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}

//---------------홈뷰-홈(탭) 끝---------------//

struct HomeViewTabHome_Previews: PreviewProvider {
    static var previews: some View {
        //        HomeViewTabHome(selectedTab: .constant("Home"))
        HomeViewTabHome(selectedTab: .constant("Home"))
            .environmentObject(PresentData())
    }
}





struct HomeCircle : View {
    
    var calculate = Calculate()
    
    @State var isCustomViewTapped = false
    
    @Binding var portionWith : String
    
    @Binding var pastaPoint : Float
    @Binding var calories : Float
    @Binding var minutes : Float
    @Binding var historyId : String
    
    @State var customPastaPoint : Float = 0
    @State var customCal : Float = 0
    @State var customMinute : Float = 0
    
    @State var averagePastaPoint : Float = 0
    @State var averageKcal : Float = 0
    @State var averageMinute : Float = 0
    
    @State var mostPastaPoint : Float = 0
    @State var mostKcal : Float = 0
    @State var mostMinute : Float = 0
    @State var mostTimes : Int = 0
    
//    @State var selectedLink : String = "Average"
    @Binding var selectedLink : String
    @State var Links = ["Custom", "Average", "Most"]
    
    
    
    init(portionWith : Binding<String>, pastaPoint : Binding<Float>, calories : Binding<Float>, minutes : Binding<Float>,  historyId: Binding<String>, selectedLink: Binding<String>){
        
        self._portionWith = portionWith
        self._pastaPoint = pastaPoint
        self._calories = calories
        self._minutes = minutes
        self._historyId = historyId
        self._selectedLink = selectedLink
        
        resetSegmentedControlStyle()

        
        
    }
    

    var body: some View {
        
        
        VStack{
            
            TabView(selection: $selectedLink) {
                
                
                // Custom
                Button(action: {
                    
                    
                    isCustomViewTapped = true
                    
                    
                }, label: {
                    ZStack(alignment: .center){
                        
                        
                        DrawingCircle(endCount: 10, lineWidth: 15, lineColor: .mainRed, isTextActivated: false)
                        
                    
                        
                        Circle()
                            .overlay{
                                Text("Tap")
                                    .bold()
                                    .foregroundColor(.mainRed)
                                    .font(.system(size: 14))
                                   
                            }
                            .frame(width: 30)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .offset(y: -100)
              
                        VStack(spacing: 0){
                                            
                            
                            VStack(spacing: 0){
                                Text("\(customCal, specifier: "%.0f") Cal")
                                    .offset(y: 15)
                                    .font(.system(size:35))
                                    .fontWeight(.bold)
                                Divider()
                                    .frame(width:180)
                                    .offset(y: 15)
                                
                            }
                            
                            
                            
                            Text("\(customPastaPoint, specifier: "%.2f")")
                                .font(.system(size:100))
                                .fontWeight(.bold)
                            
                            Text("Pasta Point")
                                .offset(y: -20)
                                .font(.system(size:20))
                                .fontWeight(.bold)


                            
                        }
                        .padding(15)
                        
                        VStack(spacing: 0){
                            Divider()
                            Text(" \(customMinute, specifier: "%.1f") m")
//                            Text(timeFormatted(Double(customMinute)))
//                                .font(.system(size:25))
                                .font(.title3)
                                .fontWeight(.bold)
                            Divider()
                            
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .offset(y: 100)
                    
                        
                    }
                    
                    .foregroundColor(.black)
                    .onAppear(perform: {
                        
                        
                        customPastaPoint = calculate.userProfileById[0].customPastaPoint
                        customMinute = calculate.userProfileById[0].customMinutes
                        customCal = calculate.userProfileById[0].customCal
                        
                        pastaPoint = customPastaPoint
                        calories = customCal
                        minutes = customMinute
                        
                    })
                    .onChange(of: isCustomViewTapped){ newValue in
                        
                        customPastaPoint = calculate.userProfileById[0].customPastaPoint
                        customMinute = calculate.userProfileById[0].customMinutes
                        customCal = calculate.userProfileById[0].customCal
                        
                        pastaPoint = customPastaPoint
                        calories = customCal
                        minutes = customMinute
                        
                    }
                    .sheet(isPresented: $isCustomViewTapped) { // Moved sheet here
                        HomeViewCustom(isCustomViewTapped: $isCustomViewTapped)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                    
                })
                
                .tag("Custom")
                
                
                // Average view
                Button(action: {
                    
                    
                    
                }, label: {
                    ZStack(alignment: .center){
                        
                        
                        DrawingCircle(endCount: 10, lineWidth: 15, lineColor: .mainRed, isTextActivated: false)
                        
                    
                        
                        Circle()
                            .overlay{
                                Image(systemName: "chart.bar.xaxis.ascending")
                                    .foregroundColor(.mainRed)
                                    .font(.system(size: 15))
                                   
                            }
                            .frame(width: 30)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .offset(y: -100)
              
                        VStack(spacing: 0){
                                            
                            
                            VStack(spacing: 0){
                                Text("\(averageKcal, specifier: "%.0f") Cal")
                                    .offset(y: 15)
                                    .font(.system(size:35))
                                    .fontWeight(.bold)
                                Divider()
                                    .frame(width:180)
                                    .offset(y: 15)
                                
                            }
                            
                            
                            
                            Text("\(averagePastaPoint, specifier: "%.2f")")
                                .font(.system(size:100))
                                .fontWeight(.bold)
                            
                            Text("Pasta Point")
                                .offset(y: -20)
                                .font(.system(size:20))
                                .fontWeight(.bold)


                            
                        }
                        .padding(15)
                        
                        VStack(spacing: 0){
                            Divider()
                            Text(" \(averageMinute, specifier: "%.1f") m")
                                
//                                .font(.system(size:25))
                                .font(.title3)
                                .fontWeight(.bold)
                            Divider()
                            
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .offset(y: 100)
                    
                        
                    }
                    .foregroundColor(.black)
                    .onAppear(perform: {
                        
                        if Settings.premiumAccess{
                            averagePastaPoint = calculate.average(search: "pastaPoint")
                            averageMinute = calculate.average(search: "cookMinutes")
                            averageKcal = calculate.average(search: "kcal")
                            
                            pastaPoint = averagePastaPoint
                            calories = averageKcal
                            minutes = floor(averageMinute * 10) / 10
                        }else{
                            
                            averagePastaPoint = calculate.averageFiveHistories()[0]
                            averageMinute = calculate.averageFiveHistories()[1]
                            averageKcal = averagePastaPoint * 200
                            
                            pastaPoint = averagePastaPoint
                            calories = averageKcal
                            minutes = floor(averageMinute * 10) / 10
                        }
                        
                     
                      
                    })
                    
                })
                .tag("Average")
                
                
                
                // Most
                
                Button(action: {
                    
                    
                    
                }, label: {
                    ZStack(alignment: .center){
                        
                        
                        DrawingCircle(endCount: 10, lineWidth: 15, lineColor: .mainRed, isTextActivated: false)
                        
                    
                        
                        VStack(alignment: .center, spacing: 0){
                            
                            Capsule()
                                .overlay{
                                    Text(mostTimes > 50 ? "50+" : "\(mostTimes)")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.mainRed)
                                       
                                    
                                }
                                .frame(width: 50, height: 23)
                                .shadow(radius: 2)
                                .foregroundColor(.white)
                        
                            
                            Text(mostTimes > 1 ? "times" : "time")
                                .foregroundColor(.gray)
                                .bold()
                                .font(.system(size: 15))

                        }
                        .foregroundColor(.black)
                        .offset(y: -100)
                        
              
                        VStack(spacing: 0){
                                            
                            
                            VStack(spacing: 0){
                                Text("\(mostKcal, specifier: "%.0f") Cal")
                                    .offset(y: 15)
                                    .font(.system(size:35))
                                    .fontWeight(.bold)
                                Divider()
                                    .frame(width:180)
                                    .offset(y: 15)
                                
                            }
                                
                            
                            Text("\(mostPastaPoint, specifier: "%.2f")")
                                .font(.system(size:100))
                                .fontWeight(.bold)
                            
                            Text("Pasta Point")
                                .offset(y: -20)
                                .font(.system(size:20))
                                .fontWeight(.bold)


                            
                        }
                        .padding(15)
                        
                        VStack(spacing: 0){
                            Divider()
                            Text(" \(mostMinute, specifier: "%.1f") m")
//                                .font(.system(size:25))
                                .font(.title3)
                                .fontWeight(.bold)
                            Divider()
                            
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .offset(y: 100)
                        
                        
                    }
                    .foregroundColor(.black)
                    .onAppear(perform: {
                        
 
                        mostKcal = calculate.most(search: "count").kcal
                        mostMinute = calculate.most(search: "count").cookMinutes
                        mostPastaPoint = calculate.most(search: "count").pastaPoint
                        mostTimes = calculate.most(search: "count").count
                        
                        historyId = calculate.most(search: "count")._id.stringValue  // 히스토리 ID를 물고 갈 수 있도록
                        Settings.mostHistory = historyId
                        
                        pastaPoint = mostPastaPoint
                        calories = mostKcal
                        minutes = mostMinute
                        
                    })
                    
                })
                .tag("Most")

            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .tabViewStyle(PageTabViewStyle())
            
    
            
            Picker("Select your Link", selection: $selectedLink) {
                ForEach(Links, id: \.self) { link in
                    Text(NSLocalizedString(link, comment: "")).tag(link)
                    

                }
                
            }
            .onAppear(perform: {
                selectedLink = Settings.homeViewOption
            })
            
            
            
            .onChange(of: selectedLink){ newValue in
                
                portionWith = selectedLink
                
            }
            .pickerStyle(SegmentedPickerStyle())
            
        }
        .padding(.bottom,30)

        
    }
    

    
}


struct HomeHistory : View {
    
    @Binding var selectedTab : String
    
    @State var selectedIndex : Int = 0
    @State var calculate = Calculate()
    
    @State var pastaPoint : Float = 0
    @State var minutes : Float = 0
    @State var historyId : String = ""
    @State var historiesCount : Int = 0
    
    @ObservedResults(UserHistory.self) var userHistory // 객체를 항상 참조하게 할것
    
    var body: some View {
        
        let userHistoryById = userHistory.where{
            try! $0.userID == ObjectId(string: Settings._id)
        }
        
        
        if userHistoryById.isEmpty{
            
            StudioCatWarning()
              
        }else{
            
            let recentFiveHistories = calculate.recentFiveHistories(search: "cookDate")
            
            VStack{
                Button(action: {
                    
                    
                    Settings.userPastaPoint = makeRound(pastaPoint)
                    Settings.userMinutes = minutes
                    Settings.historyID = historyId
                    
                    
                    
                    selectedIndex = 0
                    self.selectedTab = "Portion"
                    
                    
                    
                }, label: {
                    
                    VStack(spacing: -40){
                        
                        TabView(selection: $selectedIndex) {
                            
                            
                            ForEach(0...historiesCount, id: \.self){ index  in
                                
                                
                                VStack(alignment: .leading){
                                    
                                    HStack{
                                        
                                        
                                        HStack{
                                            Text("\(recentFiveHistories[index].cookDate, style: .date)")
                                            Text("(\(recentFiveHistories[index].cookDate, style: .time))")
                                            Image(systemName: recentFiveHistories[index].isCountable ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(.mainRed)
                                            Spacer()
                                            
                                            
                                        }
                                        .bold()
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        
                                        
                                        Spacer()
                                        
                                        if recentFiveHistories[index].count > 1 {
                                            
                                            @State var fontColor : String = "\(recentFiveHistories[index].count) times"
                                            
                                            Capsule()
                                                .foregroundColor(.mainRed)
                                                .opacity(1)
                                                .frame(width: 60, height: 20)
                                                .overlay{
                                                    Text(recentFiveHistories[index].count < 50 ? "\(recentFiveHistories[index].count) times" : "50+")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 12.5))
                                                }
                                            
                                        }else if recentFiveHistories[index].count >= 50  {
                                            
                                            Capsule()
                                                .foregroundColor(.mainRed)
                                                .frame(width: 55, height: 20)
                                                .overlay{
                                                    Text("50+")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 12.5))
                                                }
                                            
                                        }
                                        
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 1)
                                    
                                    
                                    
                                    HStack(alignment: .bottom){
 
                                        Text("\(recentFiveHistories[index].pastaPoint, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                            .foregroundColor(.mainRed)
                                        
                                        Text("pt")
                                            .font(.headline)
                                        
                                        Text("|")
                                            .foregroundColor(.gray)
                                        
                                        
                                        Text("\(recentFiveHistories[index].kcal, specifier: "%.0f")")
                                            .fontWeight(.bold)
                                        
                                        Text("cal")
                                            .font(.headline)
                                        
                                        
                                        Text("|")
                                            .foregroundColor(.gray)
                                        
                                        HStack(spacing: 0){
                                            
                                            Group{Text("★ ").foregroundColor(recentFiveHistories[index].ratings > 0 ? Color.mainRed : Color.gray) + Text("\(recentFiveHistories[index].ratings, specifier: "%.0f")")}
                                                .fontWeight(.bold)
                                            
                                
                                        }

                                        Text("|")
                                            .foregroundColor(.gray)
                                        
                                        HStack(alignment: .bottom, spacing: 5){
                                            Text("\(recentFiveHistories[index].cookMinutes, specifier: "%.1f")")
                                                .fontWeight(.bold)
                                            Text("m")
//                                                .font(.system(size: 15))
                                                .font(.headline)
                                            
                                        }

                                        
          
                                        
                                    }
                                    .onAppear(perform: {
                                        historyId = recentFiveHistories[index]._id.stringValue
                                        pastaPoint = recentFiveHistories[index].pastaPoint
                                        minutes = recentFiveHistories[index].cookMinutes
                                    })
                                    
                                    .bold()
                                    .padding(.horizontal)
                                    .font(.title3)
//                                    .font(.system(size: fontsize))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    
    
                                }
                                
                                
                                .foregroundColor(.black)
                                
                            }
                            
                            
                        }
                        .onAppear(perform: {
                            
                            
                            if calculate.recentFiveHistories(search: "cookDate").isEmpty{
                                
                                historiesCount = 0
                            }else {
                                if calculate.recentFiveHistories(search: "cookDate").count == 0{
                                    historiesCount = 0
                                    
                                }else{
                                    historiesCount  = calculate.recentFiveHistories(search: "cookDate").count - 1
                                }
                                
                            }
                            
                            
                            
                            
                        })
                        .background(Color.mainGray)
                        .frame(height: 70)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        
                    }
                })
                HStack{
                    ForEach(0...historiesCount, id: \.self){ index  in
                        Circle()
                            .fill(selectedIndex == index ? Color.mainRed : Color.gray)
                            .frame(width: 5, height: 5)
                    }
                }
                
            }
            
        }
    }
}






struct MainButton : View {
    @Binding var selectedTab : String
    @Binding var portionWith : String
    @Binding var pastaPoint : Float
    @Binding var calories : Float
    @Binding var minutes : Float
    
    let realm = try! Realm()
    @ObservedResults(UserHistory.self) var userHistory
    
    var calculate = Calculate()
    
    
    
    
    var body: some View {
        
        Button(action: {
            
            if calculate.userHistoryById.isEmpty{
                
                if portionWith == "Custom"{
                    Settings.userPastaPoint = pastaPoint
                    Settings.userCalories = calories
                    Settings.userMinutes = minutes
                    
                    Settings.mostHistory = ""
                    Settings.fromHome = true
                    Settings.fromHistory = false
                    
                    self.selectedTab = "Portion"
                }
                
                
            }else{
                

                Settings.userPastaPoint = pastaPoint
                Settings.userCalories = calories
                Settings.userMinutes = minutes
                
                if portionWith == "Most"{
                    Settings.historyID = Settings.mostHistory
                }
                
                Settings.mostHistory = ""
                Settings.fromHome = true
                Settings.fromHistory = false
                


                self.selectedTab = "Portion"
            }
            
            
    

        }, label: {
//            Text("Portion with \(portionWith)")
            Text("Portion with \(NSLocalizedString(portionWith, comment: ""))")
                .modifier(StyledButtonModifier())
            
        })
       
       
    }
        
    


}

private struct StudioCatWarning: View {
    let play = Play()
    var calculate = Calculate()
    
    var body: some View {
        
        Rectangle()
            .overlay{
                HStack{
                    
                    Image("StudioCat_trans")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)  // 크기를 줄임
                        .clipped()
                        .shadow(radius: 10)
                        .onTapGesture {
                            play.sound(name: "EasterEggCatSound", type: "mp3")
                        }
                    
                    VStack{
                        
                        Text("No History Saved!")
                            .foregroundColor(.black)
                            .bold()
                        
                        Divider()
                        
                        Text("Press the [\(Image(systemName: "circle.circle.fill")) Portion] tab to create your own portion!")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)

                }
                .padding(5)

                
            }
            .foregroundColor(.mainGray)
            .frame(height: 100)
            .cornerRadius(10)
            .shadow(radius: 1)
        

        
    }
}

private struct TopStack : View {
    
    @Binding var selectedLink : String
    
    @State var logoSize : CGFloat = 40
    @State var title : String = "Funny Cat"
    @EnvironmentObject var presentData : PresentData
    
    @AppStorage("premiumAccess") private var premiumAccess: Bool = false
    
    var body: some View {
        HStack{
            Button(action: {
                
            }, label: {
                TopStackLogo()
            })
            
            Spacer()
            
            ZStack(){

                Text("\(Settings.userEmoji) \(Settings.userName)")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
                if premiumAccess {
                    PremiumAccessBadge()
                    .offset(CGSize(width: 0.0, height: 36))
                }
                    

            }
            .shadow(radius: 2)
            .offset(CGSize(width: -1.0, height: 0.0))
            
            Spacer()
            
            Button(action: {
                
                presentData.isPresented = true
                
            }, label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize * 0.65)
                    .foregroundColor(.mainRed)
                    .padding(.trailing)
            })
            .sheet(isPresented: $presentData.isPresented) {
                HomeViewOption(selectedLink: $selectedLink)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
        }
        
        
        .padding(.vertical, -10)
    }
}
