//
//  History.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/11.
//

import SwiftUI
import RealmSwift

struct History: View {
    
    // 구현할 것
    // 1. 좀 더 예쁜 Average 구현하기 - 처리
    // 2. singleHistoryLists에서 각 리스트를 탭하면 전체가눌러지는 기능 없애기 - 처리
    // 3. 이름 타고 오는거 구현하기 - 처리
    // 4. 히스토리 삭제 구현하기 - 처리
    // 5. 1days ago 구현하기 - 처리 : 옵션화 하기로 함
    // 6. 오른쪽으로 스와이프 했을 때 타고 가는 기능 만들기 - 구현해야될거같음. count를 재야하잖아!! - 구현함
    // 7. average 보여주기 - 처리.. 이틀걸림.. 헷갈려서.. 그나마 펑션으로 최소화 하였다. 사흘걸림.. 하드코딩으로 마무리
    // 8. userHistoryById가 .isEmpty()일 때 보여줄 ui 만들기 - 처리
    // 9. isCountable 일대 평균이 나와야 되는데, 리얼타임으로 반영이 안되는중 - 처리
    // 10. MostView 구현하기 - 맨 위에 나와야 됨 중복으로 나와야 한단 뜻 - 처리
    // 11. 삭제버튼 구현후 평균값 반영 - 처리
    // 12. 평균값, 모스트셀렉티드 좀 더 예쁘게 구현 - 처리
    // 13. sort by by point, by date 구현 - 처리
    // 14. 체크 안된 곳 리스트 회색 처리 - 처리
    // 15. .onChanged이슈 : row에 붙인게 아니라 List{}에 붙여서 잘못된거 같음. 아직 미해결상태임. - 처리
    // 16. 우측으로 쓸었을 때 바로 연결돼야됨 -> 연결함
    // 17. 버그 있음 평균값 표기될 때 언래핑관련 이슈 있음. - 해결
    // 18. * 분전, * 시간 전, 1일 전 구현 - 처리했으나 옵션으로 분류
    // 19. 최초 요리일자와 마지막 요리일자업데이트 시킬것 - 아니면 히스토리에서 물고갈 경우, 날짜만 업데이트 시켜버리는거 나쁘지 않을지도? - 후자로 처리함
    // 20. 그냥 홈화면에서 들어가면 누르자마자 평균값을 불러옴 - 처리함
    // 21. 값을 그대로 물고가서 조금만 움직이면 기존값에 카운트가 덮어쓰기가 됨 - 처리함
    
    
    
    
    
    @Binding var selectedTab : String
    @State var isStatusOn : Bool = false  //화면 폴딩
    
    
    @State var isCountable : Bool = false
    
    // 평균값
    @State var averagePastaPoint : Float = 0
    @State var averageCalories : Float = 0
    @State var averageMinutes : Float = 0
    
    // 최고로 선택이 많이됨
    @State var mostSelectedId : ObjectId = ObjectId()
    
    @State var isRatingButtonTapped : Bool = false
    
    
    var body: some View {
        
        
        
        VStack{
            
            
            
            TopStack()
            
            
            if isStatusOn == true {
                    
                    VStack(spacing: 0){
                        Divider()
                
                        ShowAverage(isCountable: $isCountable, averagePastaPoint: $averagePastaPoint, averageCalories: $averageCalories, averageMinutes: $averageMinutes)
                            .padding(.horizontal, 30)
                            .padding(.vertical)
                            .background(Color.white)
                        Divider()
                        
                        
                        MostSelected(isCountable : $isCountable, mostSelectedId : $mostSelectedId)
                            .padding(.horizontal, 20)
                            .padding(.vertical)
                            .background(Color.white)
                        Divider()
                        
                    }
                    .background(Color.white)
                
                
            }else{
                Divider()
            }
            
            if Settings.premiumAccess{
                Button(action: {
                    
                    withAnimation(.interactiveSpring) {  // 디테일링 작업 - 애니메이션 추가
                        isStatusOn.toggle()
                    }
                    
                }, label: {
                    
                    Capsule()
                        .frame(width: 60, height: 15)
                        .overlay{
                            
                            HStack{
                                Image(systemName: isStatusOn ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                
                            }
                            
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            
                        }
                        .foregroundColor(.mainRed)
                    
                    
                })
                .padding(.top, 5) // Button
            }
            
           
            
            
            HistoryLists(selectedTab: $selectedTab, isStatusOn: $isStatusOn, isCountable: $isCountable, averagePastaPoint: $averagePastaPoint, averageCalories: $averageCalories, averageMinutes: $averageMinutes, mostSelectedId: $mostSelectedId, isRatingButtonTapped: $isRatingButtonTapped)
                .listStyle(PlainListStyle())
                
                .sheet(isPresented: $isRatingButtonTapped) {
                    
                    HistoryRating()
                        .presentationDetents([.fraction(0.35)])
                        .presentationDragIndicator(.visible)

                    
                }
            
        }
        
        
        
        
        
        .background(Color.mainGray)
        
    }
    
    
    
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History(selectedTab: .constant("History"))
    }
}


struct ShowAverage : View {
    
    @Binding var isCountable : Bool
    @Binding var averagePastaPoint : Float
    @Binding var averageCalories : Float
    @Binding var averageMinutes : Float
    
    
    var body: some View {
        
        
        VStack{
            
            HStack{
                
                Image(systemName: "chart.bar.xaxis.ascending")
                    .foregroundColor(.mainRed)
                Text("Average")
                
                Spacer()
                
            }
            .font(.system(size: 19))
            .foregroundColor(.black)
            .padding(.leading, -15)
            
            
            HStack{
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(averagePastaPoint, specifier: "%.2f")")
                        .font(.system(size: 40))
                        .bold()
                    Divider()
                    Text("Pasta Point")
                        .font(.system(size: 15))
                        .bold()
                    
                }
                
                
                
                Spacer()
                
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(averageCalories, specifier: "%.0f")")
                        .font(.system(size: 40))
                        .bold()
                    Divider()
                    Text("Calories")
                        .font(.system(size: 15))
                        .bold()
                    
                }
                Spacer()
                
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(averageMinutes, specifier: "%.1f")")
                        .font(.system(size: 40))
                        .bold()
                    Divider()
                    Text("Minutes")
                        .font(.system(size: 15))
                        .bold()
                    
                    
                    
                }
                .padding(.horizontal, 5)
            }
            
        }
        
        
        .onAppear{
            average()
            
        }
        
        .onChange(of: isCountable){ newValue in
            average()
        }
    }
    
    private func average(){
        
        @ObservedResults(UserHistory.self) var userHistory
        
        let userHistoryById = userHistory.where{
            
            try! $0.userID == ObjectId(string: Settings._id)
            
        }
        
        let userHistoryByIdByisCountable = userHistoryById.where{
            
            $0.isCountable == true
            
        }
        if userHistoryByIdByisCountable.isEmpty {
            averagePastaPoint = 0
            averageCalories = 0
            averageMinutes  = 0
            
        }else{
            
            averagePastaPoint =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "pastaPoint")
            averageCalories =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "kcal")
            averageMinutes =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "cookMinutes")
            
            
            // 렐름 선언
            let realm = try! Realm()
            
            // String을 objectId 값으로 변경
            let objectId = try! ObjectId(string: Settings._id)
            
            // 세팅값에 저장
            
            if let singleUserProfile = realm.object(ofType: UserProfile.self, forPrimaryKey: objectId){
                
                try! realm.write{
                    singleUserProfile.avgCal = averageCalories
                    singleUserProfile.avgMinutes = averageMinutes
                    singleUserProfile.avgPastaPoint = averagePastaPoint
                    
                }
            }
            
        }
        
    }
}

private struct StudioCatWarning: View {
    
    let play = Play()
    
    var body: some View {
        ScrollView{
            
            VStack{
                Rectangle()
                    .frame(height:300)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .overlay{
                        VStack{
                            Image("StudioCat_trans")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)  // 크기를 줄임
                                .shadow(radius: 5)
                                .clipped()
                                .onTapGesture {
                                    play.sound(name: "EasterEggCatSound", type: "mp3")
                                }
                            
                            
                            Text("No History Saved")
                                .bold()
                                .font(.system(size: 25))
                            Divider()
                            HStack{
                                Image(systemName: "circle.circle.fill")
                                    .foregroundColor(.mainRed)
                                    .font(.system(size: 30))
                                Text("Press the [Portion] tab to create your own portion!")
                            }
                            Divider()
                        }
                        .padding()
                        
                    }
                
            }
            .frame(width: 350)
            .padding()
            .listRowBackground(Color.clear)
            
        }
        
        
        
    }
}

struct HistoryLists: View {
    
    let realm = try! Realm()
    @ObservedResults(UserHistory.self) var userHistory
    
    // 화면전환
    @Binding var selectedTab : String
    @Binding var isStatusOn : Bool
    
    // 날짜관련
    @State var typeOfDate : Bool = false // 최종작업때 옵션
    
    // sort 관련 옵션 설정
    @State var sortBy : Bool = false
    @State var sortOption : String = "date"
    @State var sortKeyPath : String = "cookDate"
    @State var sortAscending : Bool = false
    
    // 평균값 바인딩
    @Binding var isCountable : Bool
    @Binding var averagePastaPoint : Float
    @Binding var averageCalories : Float
    @Binding var averageMinutes : Float
    
    // 최고값 바인딩
    @Binding var mostSelectedId : ObjectId
    
    // 리스트별 ratings버튼
    @State var ratings : Float = 0
    @State var rate : Bool = false
    
    @Binding var isRatingButtonTapped : Bool
    
    @EnvironmentObject var presentData : PresentData
    
    let calculate = Calculate()
    
    
    
    var body: some View {
        
    
        
        // 객체 로드
        
        
        let userHistoryById = userHistory.where{
            
            try! $0.userID == ObjectId(string: Settings._id)
            
        }
        
        let ascendingSortedUsers = userHistoryById.sorted(byKeyPath: sortKeyPath, ascending: sortAscending)
        
        var historyCount : Int{
            if Settings.premiumAccess{
                return ascendingSortedUsers.count
            }else{
                if ascendingSortedUsers.count <= 5{
                    return ascendingSortedUsers.count
                }
                return 5
            }
        }

        if userHistoryById.isEmpty {
            StudioCatWarning()
                .onAppear(perform: {
                    isStatusOn = false
                })
        } else{
            
            
            HStack{
                
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .foregroundColor(.mainRed)
                Text("History")
                Spacer()
                
                if Settings.premiumAccess{
                    HStack{
                        
                        if sortOption == "date"{
                            
                            Button(action: {
                                
                                typeOfDate.toggle()
                                
                            }, label: {
                                Capsule()
                                    .stroke(Color.gray, lineWidth: 2)
                                    .overlay{
                                        Text(typeOfDate ? "full" : "short")
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                
                                    .frame(width: 70, height: 20)
                            })
                            
                        }
                        
                        
                        
                        Button(action: {
                            sortBy.toggle()
                            
                        }, label: {
                            
                            Capsule()
                                .stroke(Color.gray, lineWidth: 2)
                                .overlay{
                                    Text(sortOption)
                                        .foregroundColor(.black)
                                }
                            
                                .frame(width: 70, height: 20)
                        })
                        .actionSheet(isPresented: $sortBy) {
                            ActionSheet(title: Text("Sort"), message: Text("Please select the sorting option you would like to use"), buttons: [
                                
                                .default(Text("Date")) {
                                    
                                    // option 1
                                    sortOption = "date"
                                    sortKeyPath = "cookDate"
                                    
                                    
                                },
                                .default(Text("Pasta Point")) {
                                    
                                    // option 1
                                    sortOption = "point"
                                    sortKeyPath = "pastaPoint"
                                    
                                },
                                .default(Text("Count")) {
                                    
                                    // option 1
                                    sortOption = "count"
                                    sortKeyPath = "count"
                                    
                                    
                                },
                                .default(Text("Ratings")) {
                                    
                                    // option 1
                                    sortOption = "ratings"
                                    sortKeyPath = "ratings"
                                    
                                    
                                },
                                .default(Text("Minutes")) {
                                    
                                    // option 1
                                    sortOption = "minutes"
                                    sortKeyPath = "cookMinutes"
                                    
                                },
                                
                                    .cancel()
                            ])
                        }
                        
                        Button(action: {
                            
                            sortAscending.toggle()
                            
                        }, label: {
                            Image(systemName: sortAscending ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                .foregroundColor(.black)
                        })
                        
                        
                    }
                    .font(.system(size: 15)) // HStack
                }
                
               
                
                
            }
            .font(.system(size: 20))
            .padding(.horizontal)
            .listRowBackground(Color.clear)
            
            List{
                
                
                ForEach(ascendingSortedUsers[0..<historyCount], id:\._id){ singleUserHistory in
                    
                    Button(action: {
                        
                        isRatingButtonTapped = true
                        Settings.ratingHistory = singleUserHistory._id.stringValue
                        
                    }, label: {
                        
                        
                        VStack{
                            
                            HStack{
                                
                                let daysAgoTranslated = NSLocalizedString("\(daysAgo(from: singleUserHistory.cookDate))", comment: "")
                                
//                                Text(typeOfDate ? "\(singleUserHistory.cookDate, style: .date) (\(singleUserHistory.cookDate, style: .time))" : "\(daysAgo(from: singleUserHistory.cookDate))")
//                                
                                Text(typeOfDate ? "\(singleUserHistory.cookDate, style: .date) (\(singleUserHistory.cookDate, style: .time))" : "\(daysAgoTranslated)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                                    .onAppear{
                                        let mostSelectedUserHistory = userHistoryById.sorted(byKeyPath: "count", ascending: false).first!
                                        mostSelectedId = mostSelectedUserHistory._id
                                    }
                                
                                
                                // 여기
                                if singleUserHistory._id.stringValue == mostSelectedId.stringValue {
                                    Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.mainRed)
                                    .font(.system(size: 15))
                                       
                                }
                        
                                
                                Spacer()
                                
                                
                                if singleUserHistory.count > 1 {
                                    
                                    @State var fontColor : String = "\(singleUserHistory.count) times"
                                    
                                    Capsule()
                                        .foregroundColor(.mainRed)
                                        .opacity(1)
                                        .frame(width: 60, height: 20)
                                        .overlay{
                                            Text(singleUserHistory.count < 50 ? "\(singleUserHistory.count) times" : "50+")
                                                .foregroundColor(.white)
                                                .font(.system(size: 12.5))
                                        }
                                    
                                }else if singleUserHistory.count >= 50  {
                                    
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
                            
                            
                            HStack{
                                
                                let columnSpacing : CGFloat = 40
                                
                                
                                Group {
                                    
                                    Text("\(singleUserHistory.pastaPoint, specifier: "%.2f")")
                                        .font(.title3)
                                        .frame(maxWidth: columnSpacing + 7)
                                        .bold()
                                        .foregroundColor(.mainRed)
                                        .padding(.trailing, -8)
                                    Text("pt")
                                    
                                    
                                    Text("|")
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                    
                                    Text("\(singleUserHistory.kcal, specifier: "%.0f")")
                                        .frame(maxWidth: columnSpacing + 10)
                                        .padding(.trailing, -7)
                                    
                                    Text("cal")
                                    
                                    
                                    Text("|")
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                    
                                    
                                    Group{Text("★ ").foregroundColor(singleUserHistory.ratings > 0 ? Color.mainRed : Color.gray) + Text("\(singleUserHistory.ratings, specifier: "%.0f")")}
                                        .frame(maxWidth: columnSpacing - 7)
                                    
                                    Text("|")
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                    
                                    Text("\(singleUserHistory.cookMinutes, specifier: "%.1f") ")
//                                        .frame(maxWidth: columnSpacing - 1)
                                    Text("m")
                                        .padding(.leading, -10)
                                    
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                                
                                .opacity(singleUserHistory.isCountable ? 1 : 0.4)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    
                                    let thawSingleUserHistory = singleUserHistory.thaw()!
                                    
                                    try! realm.write{
                                        
                                        thawSingleUserHistory.isCountable.toggle()
                                        
                                    }
                                    
                                    isCountable.toggle()
                                    
                                    
                                    
                                }, label: {
                                    HStack{
                                        Image(systemName: "circle")
                                            .foregroundColor(.clear)
                                        Image(systemName: singleUserHistory.isCountable ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.mainRed)
                                    }
                                    
                                    
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                
                            }
                            
                            
                            .font(.system(size: 18))
                            
                        }
                        
                    }) // 리스트 버튼 마지막
                    .listRowBackground(singleUserHistory.isCountable ? Color.white : Color.mainGray)
                    .swipeActions {
                        
                        Button("Delete", systemImage: "minus.circle", role: .destructive) {
                            
                            let thawSingleUserHistory = singleUserHistory.thaw()!
                            
                            try! realm.write{
                                
                                realm.delete(thawSingleUserHistory)
                                
                            }
                            
                            average()
                            
                        }
                    }
                    .swipeActions(edge: .leading) {
                        
                        Button("quick link", systemImage: "arrowshape.right.fill") {

                            // 히스토리 아이디 저장
                            Settings.historyID = singleUserHistory._id.stringValue
                            Settings.userPastaPoint = singleUserHistory.pastaPoint
                            Settings.userMinutes = singleUserHistory.cookMinutes
                            
                            selectedTab = "Portion"
                            
                            // 히스토리 족적 남기기
                            Settings.fromHistory = true
                            Settings.fromHome = false

                        }
                        .tint(.green)
                        
                        Button("Quick\nPortion"){

                        }
                        .tint(.green)
  
                    }
                    
                    .bold()
                    .foregroundColor(.black)
                    
                  
                }
                
                if !Settings.premiumAccess && historyCount >= 5{
                    HStack{
                        Spacer()
                        PurchaseAlert()
                        Spacer()
                    }
                }
                
                
                
            }
            
          
//            admobBanner()         // 24.06.20 삭제
            
        }
    }
    
    
    
    private func average(){
        
        
        let userHistoryById = userHistory.where{
            
            try! $0.userID == ObjectId(string: Settings._id)
            
        }
        
        let userHistoryByIdByisCountable = userHistoryById.where{
            
            $0.isCountable == true
            
        }
        
        if userHistoryByIdByisCountable.isEmpty {
            averagePastaPoint = 0
            averageCalories = 0
            averageMinutes  = 0
            
        }else{
            
            averagePastaPoint =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "pastaPoint")
            averageCalories =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "kcal")
            averageMinutes =  makeAverage(realmTable: userHistoryByIdByisCountable, column: "cookMinutes")
            
            isCountable.toggle()
            
        }
        
        
    }
}

struct MostSelected: View {
    
    @Binding var isCountable : Bool
    @Binding var mostSelectedId : ObjectId
    
    @State var count : Int = 0
    @State var pastaPoint : Float = 0
    @State var calories : Float = 0
    @State var stars : Float = 0
    @State var minutes : Float = 0
    
    
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.mainRed)
                Text("Most Selected")
                
                Text(count > 1 ? "- \(count) times" : "- \(count) time")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 15.5))
                
                
                Spacer()
                
                
            }
            .font(.system(size: 18))
            .padding(.leading, -8)
            .listRowBackground(Color.clear)
            
            HStack{
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(pastaPoint, specifier: "%.2f")")
                        .font(.system(size: 30))
                        .bold()
                    Divider()
                    Text("Pasta Point")
                        .minimumScaleFactor(0.9)
                        .font(.system(size: 15))
                        .bold()
                    
                }
                
                Spacer()
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(calories, specifier: "%.0f")")
                        .font(.system(size: 30))
                        .bold()
                    Divider()
                    Text("Calories")
                        .font(.system(size: 15))
                        .bold()
                    
                }
                
                Spacer()
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(stars, specifier: "%.0f")")
                        .font(.system(size: 30))
                        .bold()
                    Divider()
                    Text("Rating")
                        .font(.system(size: 15))
                        .bold()
                    
                }
                
                Spacer()
                
                VStack(spacing: 10){
                    Divider()
                    Text("\(minutes, specifier: "%.1f")")
                        .font(.system(size: 30))
                        .bold()
                    Divider()
                    Text("Minutes")
                        .font(.system(size: 15))
                        .bold()
                    
                }
                
            }
            .onAppear{
                
                mostSelected()
            }
            .onChange(of: isCountable){ newValue in
                
                mostSelected()
                
            }
            //            .padding(.horizontal, 30)
        }
        
    }
    
    
    private func mostSelected(){
        
        
        @ObservedResults(UserHistory.self) var userHistory
        
        let userHistoryById = userHistory.where{
            
            try! $0.userID == ObjectId(string: Settings._id)
            
        }
        if userHistoryById.isEmpty{
            
            count = 0
            pastaPoint = 0
            calories = 0
            stars = 0
            minutes = 0
            
            
        }else{
            
            let mostSelectedUserHistory = userHistoryById.sorted(byKeyPath: "count", ascending: false).first!
            
            count = mostSelectedUserHistory.count
            pastaPoint = mostSelectedUserHistory.pastaPoint
            calories = mostSelectedUserHistory.kcal
            stars = mostSelectedUserHistory.ratings
            minutes = mostSelectedUserHistory.cookMinutes
            mostSelectedId = mostSelectedUserHistory._id
        }
        
    }
}


private struct TopStack : View {
    
    @State var logoSize : CGFloat = 40
    @State var title : String = "Funny Cat"
    @State var isPresented : Bool = false
    
    var body: some View {
        HStack{
            Button(action: {
                
            }, label: {
                
                TopStackLogo()
                
            })
            
            Spacer()
            
            ZStack{
                HStack(spacing: -10){
                    
                    Text("\(Settings.userEmoji) \(Settings.userName)")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                    
                }
                .shadow(radius: 2)
                .offset(CGSize(width: -1.0, height: 0.0))
        
            }
           
            
            Spacer()
            
            Button(action: {
                
                
                
            }, label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize * 0.65)
                    .foregroundColor(.clear)
                    .padding(.trailing)
            })
            
            
        }
        .padding(.vertical, -10)
    }
}

private struct PurchaseAlert: View {
    
    @State var isPurchaseAlertTapped : Bool = false
    
    
    var body: some View {
    

        Button(action: {
            isPurchaseAlertTapped = true
        }, label: {
                Text("Want to Manage More?")
                      .bold()
                      .foregroundColor(.mainRed)
            })
        .sheet(isPresented: $isPurchaseAlertTapped) { // Moved sheet here
            InAppPurchase()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
           
            
                
        
        
    }
}
