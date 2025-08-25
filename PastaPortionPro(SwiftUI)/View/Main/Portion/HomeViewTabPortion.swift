//
//  testTwo.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/10/07.
//

import SwiftUI
import RealmSwift
import AVFoundation

struct HomeViewTabPortion: View {

    
    @Binding var selectedTab : String
    
    let realm = try! Realm()
    @ObservedResults(UserHistory.self) var userHistory
    
    
    @StateObject private var viewModel = DeviceScreenSizeViewModel()
    @State private var modelName : String=""
    @State private var screenSize : CGSize=CGSize.zero
    @State private var widthCm = 0.0
    @State private var heightCm = 0.0
    
    let scale = UIScreen.main.scale //포인트 * Scale = 픽셀
    @State private var ppi : Int = 0
    @State private var standardPastaPoint : CGFloat = 7/8 //- 나중에 옵션에서 변경가능함
    @State private var standardKcal : CGFloat = 200 //- 나중에 옵션에서 변경가능
    
    @State private var kcal : CGFloat = 0.0
    @State private var pastaPoint : CGFloat = 0.0
    
    @State private var circleSize: CGFloat = 100.0
    private var basicCircleSize : CGFloat = 0.0
    @State private var reversedCircleSize: CGFloat = 100.0
    
    @State private var sliderValue: Double = 0
    
    @State private var value: Double = 0.5
    
    
    @State private var sliderPoint : Double = 0.0
    @State private var geometryWidth : CGFloat = 0.0
    
    @State private var changePtCal : Bool = false
    
    @State private var isCustomViewTapped : Bool = false
    
    @State private var customPastaPoint : CGFloat = 1
    
    
    //지오메트리값 받아오기 - 실제 아이폰 실측사이즈
    @State var realWidth : CGFloat = 1
    @State var maxPastaPoint : CGFloat = 1.0
    
    // 매뉴얼 입력
    @State var manualInput : Bool = false
    
    
//    var maxPastaPoint : CGFloat{
//        
//        get{
//            
//            let scale = UIScreen.main.scale
//            let standardOnePoint : CGFloat = 7/8 // 1 pasta point : 2cm -> inch
//            let ppi = viewModel.fetchPPI()
//            let maxPastaPoint = viewModel.pastaPoint(circleSize: UIScreen.main.bounds.width, scale: scale, standardPastaPoint: standardOnePoint, ppi: ppi ?? 0)
//            
//            print("Device Info -\(String(UIDevice.current.name)) Width: \(UIScreen.main.bounds.width), Height: \(UIScreen.main.bounds.height), PPI: \(ppi ?? 0), Max Pasta Point: \(maxPastaPoint)")
//            
//            
//            print("Screen Size ----- \(UIScreen.main.bounds.width)---")
//            
//            
//            return round(CGFloat(maxPastaPoint * 100)) / 100 // 소수점 두번째 이하는 버림
//            
//        }
//
//    }

    
    // Picker() 관련설정
    
    @State private var selectedPerson = 1// 초기 선택값
   
    let person : [Image] = [Image(systemName:"circle.circle"), Image(systemName:"person"), Image(systemName:"person.2"), Image(systemName:"person.3")]
    let personDotFill : [Image] = [Image(systemName:"circle.circle.fill"), Image(systemName:"person.fill"), Image(systemName:"person.2.fill"), Image(systemName:"person.3.fill")]
    
    
    //Picker()색상변경
    init(selectedTab : Binding<String>) {
        
        self._selectedTab = selectedTab

        resetSegmentedControlStyle()
    }
    


    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                
                TopStack(changePtCal: $changePtCal)
                    .padding(.bottom, -45)
                    
                
                // ---- 원 시작 ----
                
                ZStack{
                    Text("PLACE\nYOUR\nPASTA\nHERE")
                        .font(.system(size:13))
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                    
                    
                    // (시작) 각 인분 가늠자 역할 원
                    Circle()
                        .stroke(Color.gray, lineWidth: 8)
                        .opacity(0.1)
                        .frame(width: viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 1))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4) // 원의 위치 설정
                    
                    Circle()
                        .stroke(Color.gray, lineWidth: 8)
                        .opacity(0.1)
                        .frame(width: viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 2))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4) // 원의 위치 설정
                    
                    
                    if oldPhoneSupport(){
                        Circle()
                            .stroke(Color.gray, lineWidth: 8)
                            .opacity(0.1)
                            .frame(width: viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 3))
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 4) // 원의 위치 설정
                    }
                   
                    
                    // (종료) 각 인분 가늠자 역할 원 종료
                    
                    Circle()
                        .stroke(Color.mainRed, lineWidth: 8)
                        .frame(width: circleSize, height: circleSize)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 4) // 원의 위치 설정
                        
                    
                }
                .onAppear(perform: {
                    realWidth = geometry.size.width
                    print("realWidth ::: \(realWidth)")
                    maxPastaPoint = round(viewModel.pastaPoint(circleSize: realWidth, scale: scale, standardPastaPoint: 7/8, ppi: ppi) * 100) / 100
                    print(maxPastaPoint)
                    
                    
                    
                })
                
                
                // ---- 원 종료 ----
                
                VStack{
                    
                    VStack(spacing: 0){
                       
                        
                        //작업중
                        
                        
                        Text(changePtCal ? "\(String(format: "%.2f", pastaPoint)) Point" : "\(String(format: "%.0f", kcal)) Calories")
                            .offset(y: 15)
                            .font(.system(size:25))
                            .fontWeight(.bold)
                           
         
                        HStack{
                            
                            Spacer()
                            
                            if selectedPerson == 0{
                                Button(action: {
                                    
                                    isCustomViewTapped = true
                                    
                                }, label: {
                                    Circle()
                                        .overlay{
                                            Text("Tap")
                                                .bold()
                                                .foregroundColor(.mainRed)
                                                .font(.footnote)
                                               
                                        }
                                        .frame(width: 30)
                                        .foregroundColor(.white)
                                        .shadow(radius: 1)
                                        
                                })
                                .sheet(isPresented: $isCustomViewTapped) { // Moved sheet here
                                    PortionCustom(isCustomViewTapped: $isCustomViewTapped, customPastaPoint: $customPastaPoint)
                                        .presentationDetents([.medium])
                                        
                                }
                            }else{
                                Button(action: {
                                    
                                   
                                    
                                }, label: {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundColor(.clear)
                                      
                                        
                                })
                            }
                            
                            
                            
                            
                            Spacer()
                          
                            VStack{
                                
                                Text(changePtCal ? "\(String(format: "%.0f", kcal))" : "\(String(format: "%.2f", pastaPoint))")
                                    .font(.system(size:100))
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                // 출시 이후
//                                    .onTapGesture {
//                                        manualInput = true
//                                    }
//                                
//                                    .sheet(isPresented: $manualInput) {
//                                        ManualPastaPoint()
//                                            .presentationDetents([.height(500)])
//                                            .presentationDragIndicator(.visible)
//                                    }
//                                
                                
                                Text(changePtCal ? "Calories" : "Pasta Point")
                                    .offset(y: -20)
                                    .font(.system(size:20))
                                    .fontWeight(.bold)
                            }
                            
                        
                            
                            Spacer()
                            
                            Button(action: {
                                
                                changePtCal.toggle()
             
                                
                            }, label: {

                                Circle()
                                    .overlay{
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .bold()
                                            .foregroundColor(.mainRed)
                                            .rotationEffect(.degrees(90))
                                            .font(.system(size: 15))
                                           
                                    }
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                            })
                            
                            Spacer()
                        }
                        .onAppear(perform: {
                            changePtCal = Settings.portionViewOption
                        })
                        
                        
                        
                    }
                    .offset(y: 20)
                  
                    
                    VStack{
                        
                        Picker("Select Quick Portion", selection: $selectedPerson) {
                            ForEach(0..<person.count, id: \.self) { index in
                                if selectedPerson == index {
                                    personDotFill[index]
                                        .tag(index)
                                       
                                    
                                }else{
                                    person[index]
                                        .tag(index)
                                }
                                
                            }
                        }
                        .padding(.vertical)
                        .frame(width: 250)
                        .pickerStyle(SegmentedPickerStyle())
                        .onAppear(perform: {
                                
                            if Settings.historyID != "" || Settings.fromHome {
                                pastaPoint = CGFloat(Settings.userPastaPoint)
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: pastaPoint)
                                
                            }else{
                                pastaPoint = 1
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: pastaPoint)
                            }
                                
                                
                   
                          
                            
                        })
                        .onChange(of: customPastaPoint, perform: { value in

                            
                            pastaPoint = customPastaPoint
                            
                        })
                        
                        .onChange(of: selectedPerson) { newValue in
                            // 새로운 값에 대한 액션 수행
                            if selectedPerson == 1 {
                                pastaPoint = 1
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 1)
                
                            } else if selectedPerson == 2 {
                                pastaPoint = 2
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 2)
                            } else if selectedPerson == 3 {
                                pastaPoint = 3
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 3)
                            } else if selectedPerson == 0{
                                
                                
                                let calculate = Calculate()
                                customPastaPoint = CGFloat(calculate.userProfileById.first?.customPastaPoint ?? 1)
                                pastaPoint = customPastaPoint
                                
                                circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: customPastaPoint)
                                
                            }
                        }
                        
                        HStack{
                            
                            
//                             ---- 슬라이더 시작 ----

                            Slider(value: $pastaPoint, in: 0...maxPastaPoint, step: 0.1)
                                .tint(.mainRed)
                            

                                
                                .onChange(of: pastaPoint) { newValue in
                                    
                                    
          
                                    circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: pastaPoint)
                                    
                                    kcal = pastaPoint * standardKcal


                                    
                                }
                            
                            
                             
                            
                            
                                .frame(width: 300)
                                .onAppear(perform:{
                                    let scale = UIScreen.main.scale
                                    let pixelWidth = Int(UIScreen.main.bounds.width * scale)
                                    let pixelHeight = Int(UIScreen.main.bounds.height * scale)
//                                    let ppi = viewModel.fetchPPI(forWidth:pixelWidth,andHeight:pixelHeight)
                                    let ppi = viewModel.fetchPPI()
                                    self.ppi = ppi ?? 0
                                    let sizeInCm = viewModel.calculateSize(forWidth: Int(pixelWidth), andHeight: Int(pixelHeight), withPPI: ppi ?? 0)
                                    
                                    circleSize = viewModel.reversePastaPoint(circleSize: circleSize, scale: scale, standardPastaPoint: standardPastaPoint, ppi: self.ppi, pastaPoint: 1)
                                    
                                    widthCm = sizeInCm.widthCm
                                    
                                    heightCm = sizeInCm.heightCm
                                    
                                    geometryWidth = geometry.size.width
                                    
                                    
                                })
                            
                            // ---- 슬라이더 종료 ----
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                VStack{
                 
                    
                    
                    // 홈화면에서 데이터를 물고 오지 않음
                    // Lock버튼 만들기 : 물고올 때, 슬라이더를 비활성화 시키고 lock버튼으로 변경가능하게!
                    // 포션탭에서 lock버튼을 해제하면 타이머 탭에도 락버튼 해제
                    
                    
                    Button(action: {
                        
                        
                        if Settings.newHistoryID == "" && Settings.historyID == ""{     // 히스토리가 완전 없을 경우
                            
                            saveNewUserHistory()
                       
                        }else{                                                      // 기존 히스토리가 있을 경우
                            
                            if Settings.userPastaPoint != Float(pastaPoint) {
                                saveNewUserHistory()
                            }else{
                                Settings.userPastaPoint = Float(pastaPoint)
                                Settings.userCalories = Float(kcal)
                            }
                            
                          
                        }
                        
                       
                       
                        selectedTab = "Timer"                                       // 타이머 탭으로 이동
                       


                        
                    }, label: {
                        Text("Save & Start Timer")
                    })
                    .modifier(StyledButtonModifier())
                    .padding(.horizontal, 25)
                    
//                    admobBanner()             // 2024.06.20 삭제
                    
                }
                
            }
            
            
        }
    }
    private func saveNewUserHistory(){
        // DB 저장 관련
        let newUserHistory = UserHistory()
        
        newUserHistory.userID = try! ObjectId(string: Settings._id)
        newUserHistory.kcal = Float(kcal)
        newUserHistory.cookDate = Date()
        newUserHistory.pastaPoint = Float(pastaPoint)
        $userHistory.append(newUserHistory)

        
        // UserDefaults관련
        Settings.newHistoryID = newUserHistory._id.stringValue  // 새로운 히스토리 이력추가
        Settings.historyID = ""                                     // 히스토리 초기화
        Settings.userPastaPoint = Float(pastaPoint)
        Settings.userCalories = Float(kcal)

    }
    



}

private struct TopStack : View {
   
    @State var logoSize : CGFloat = 40
    @State var title : String = "Funny Cat"
    @EnvironmentObject var presentData : PresentData
    @State var isPresented : Bool = false
    
    @Binding var changePtCal : Bool
   
   var body: some View {
       HStack{
           Button(action: {
               
           }, label: {
               
               TopStackLogo()

           })
           
           Spacer()
           
           HStack(spacing: -10){

               Text("\(Settings.userEmoji) \(Settings.userName)")
                   .font(.system(size: 20))
                   .bold()
                   .foregroundColor(.black)
                   .padding()

           }
           .shadow(radius: 2)
           .offset(CGSize(width: -1.0, height: 0.0))
           
           Spacer()

           
           Button(action: {
               
              isPresented = true
               
           }, label: {
               Image(systemName: "gearshape.fill")
                   .resizable()
                   .scaledToFit()
                   .frame(width: logoSize * 0.65)
                   .foregroundColor(.mainRed)
                   .padding(.trailing)
           })
           .sheet(isPresented: $isPresented) {
               PortionOption(changePtCal: $changePtCal)
                   .presentationDetents([.medium])
                   .presentationDragIndicator(.visible)
               
           }
           
       }
       .padding(.vertical, -10)
   }
}




#Preview {
    HomeViewTabPortion(selectedTab: .constant("Portion"))
}

