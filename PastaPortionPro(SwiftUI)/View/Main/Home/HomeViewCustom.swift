//
//  HomeViewCustom.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 4/25/24.
//

import SwiftUI

// 1. 소수점 두자리 숫자까지 실질반영 - floor()함수로 반영
// 2. 화면 사이즈 구해서 최대값 구할 수 있게 - 간단하게 max()표시함 - 처리


struct HomeViewCustom: View {
    
    // 파스타포인트 계산
    var viewModel = DeviceScreenSizeViewModel()
    var maxPastaPoint : Float{
        
        get{
            
            let scale = UIScreen.main.scale
            
            let standardOnePoint : CGFloat = 7/8 // 1 pasta point : 2cm -> inch
            //            let ppi = viewModel.fetchPPI(forWidth:Int(pixelWidth),andHeight:pixelHeight)
            let ppi = viewModel.fetchPPI()
            let maxPastaPoint = viewModel.pastaPoint(circleSize: UIScreen.main.bounds.width, scale: scale, standardPastaPoint: standardOnePoint, ppi: ppi ?? 0)
            return floor(Float(maxPastaPoint * 100)) / 100 // 소수점 두번째 이하는 버림
            
        }
        
    }
    
    // 바인딩
    @Binding var isCustomViewTapped : Bool
    
    // 칼로리 관련
    @State var pastaPoint : Float = 1
    
    var calories:  Float  {
        get {
            return ceil(pastaPoint * 200)
        }
        
    }
    // 타이머 관련
    @State var minutes : Float = 8
    @State var isPlusButtonDisabled = false
    @State var isMinusButtonDisabled = false
    
    // 커스텀데이터 프로필저장
    var calculate = Calculate()
    
    
    // Slider Step제어 - v1.1.0 추가
    @State var step : Float = 0.1
    
    var body: some View {
        
        VStack{
            
            Capsule()
                .frame(width: 60, height: 7)
                .foregroundColor(.clear)
                .padding()
            
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                
                Button(action: {
                    
                    pastaPoint = 1
                    minutes = 8
                    
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.mainRed)
                        .font(.system(size: 25))
                })
                Spacer()
                Text("Custom Settings")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    
                    isCustomViewTapped.toggle()
                    
                }, label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.mainRed)
                        .font(.system(size: 25))
                })
            }
            .padding(.horizontal)
            
            
            Divider()
            
            Spacer()
            
            ZStack{
                Circle()
                    .stroke(Color.white, lineWidth: 14.0)
                    .shadow(radius: 0.1)
                    .frame(width: 230, height: 230)
                
                Circle()
                    .stroke(Color.mainRed, lineWidth: 6.0)
                    .frame(width: 230, height: 230)
                    .foregroundColor(.white)
                    .shadow(radius:3)
                    .overlay{
                        VStack(spacing: 3){
                            
                            VStack(spacing: -7){
                                Text("\(calories, specifier: "%.0f")")
                                    .bold()
                                    .font(.system(size: 55))
                                Text("Calories")
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            Divider()
                            VStack(spacing: -7){
                                Text("\(pastaPoint, specifier: "%.2f")")
                                    .bold()
                                    .font(.system(size: 55))
                                Text("Pasta Point")
                                    .font(.system(size: 15))
                                    .bold()
                                Text("max \(maxPastaPoint, specifier: "%.2f")")
                                    .bold()
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                                
                                
                            }
                            
                            
                        }
                        .padding()
                        
                    }
                    .onChange(of: pastaPoint, perform: { value in
                        pastaPoint = floor(Float(pastaPoint * 100)) / 100
                    })
                    .onAppear(perform: {
                        
                        self.pastaPoint = calculate.loadCustomData(search: "pastaPoint")
                        
                    })
            }
            .padding()
            
            Spacer()
            
            HStack{
                
                Spacer()
                Button(action: {
                    
                    pastaPoint -= 0.01
                    
                }, label: {
                    Image(systemName: "minus.circle")
                        .font(.title2)
                        .foregroundColor(.mainRed)
                })
                Spacer()
                
                Slider(value: $pastaPoint, in: 0...maxPastaPoint, step: step)
                    .tint(Color.mainRed)
                    .frame(width: (UIScreen.main.bounds.width) - 140)
                    .onChange(of: step, perform: { value in
                        pastaPoint = floor(Float(pastaPoint * 10)) / 10
                    })
                    .onChange(of: pastaPoint, perform: { value in
                        if value < 0{
                            pastaPoint = 0
                        }else if value > maxPastaPoint{
                            pastaPoint = maxPastaPoint
                        }
                    })
                
                Spacer()
                Button(action: {
                    
                    pastaPoint += 0.01
                    
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.mainRed)
                })
                Spacer()
            }
            
            Spacer()
            Divider()
            
            
            Spacer()
            
            HStack{
                Spacer()
                
                Button(action: {
                    
                    if isPlusButtonDisabled == true {
                        
                        isPlusButtonDisabled = false
                        
                    }
                    
                    if minutes > 3 {
                        minutes -= 0.5
                        
                    }else {
                        isMinusButtonDisabled = true
                    }
                    
                }, label: {
                    VStack{
                        
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.mainRed)
                            .font(.system(size: 30))
                        
                    }
                    
                })
                .opacity(isMinusButtonDisabled ? 0.1 : 1)
                
                
                
                Spacer()
                VStack{
                    
//                    Text(typeOfPasta(minutes: minutes)[0])
                    Text(NSLocalizedString(typeOfPasta(minutes: minutes)[0], comment: ""))
                        .font(.system(size: 20))
                        .bold()
                    
//                    Text(typeOfPasta(minutes: minutes)[1])
                    Text(NSLocalizedString(typeOfPasta(minutes: minutes)[1], comment: ""))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.gray)
                    
                    
                    Text("\(minutes, specifier: "%.1f")")
                        .bold()
                        .font(.system(size: 60))
                    Text("minutes")
                        .bold()
                    Text("max 20")
                        .foregroundColor(.gray)
                        .bold()
                        .font(.system(size: 13))
                    
                    
                }
                .frame(width: 160)
                .onAppear(perform: {
                    
                    self.minutes = calculate.loadCustomData(search: "minutes")
                    
                })
                
                Spacer()
                Button(action: {
                    
                    if isMinusButtonDisabled == true {
                        
                        isMinusButtonDisabled = false
                        
                    }
                    
                    if minutes < 20{
                        
                        minutes += 0.5
                        
                    }else{
                        isPlusButtonDisabled = true
                    }
                    
                    
                    
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.mainRed)
                        .font(.system(size: 30))
                })
                .opacity(isPlusButtonDisabled ? 0.1 : 1)
                
                
                Spacer()
                
            }
            .padding()
            
            
            
            
            
            
            
        }
        .foregroundColor(.black)
        
        
        
        
        Button(action: {
            
            
            if calculate.userProfileById.isEmpty{
                isCustomViewTapped.toggle()
            }else{
                calculate.saveCustomData(pastaPoint: pastaPoint, minutes: minutes, calories: calories)
                isCustomViewTapped.toggle()
                
                print("The Data Succesfully Saved !\(calculate.userProfileById)")
                
            }
            
            
            
        }, label: {
            Text("Save")
                .modifier(StyledButtonModifier())
            
        })
        .padding()
        
        
        
    }
    
    
    
    private func typeOfPasta(minutes: Float) -> [String]{
        
        if minutes <= 10{
            
            return ["Al Dente", "Firm and Chewy"]
            
            
        } else if minutes <= 15{
            
            return ["Cottura","Softer than Al Dente"]
            
            
        }
        else{
            
            return ["Ben Cotto","Very Soft, Lacking Firmness"]
            
            
        }
    }
}

#Preview {
    HomeViewCustom(isCustomViewTapped: .constant(true))
}
