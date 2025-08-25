//
//  PortionCustom.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/24/24.
//

import SwiftUI

struct PortionCustom: View {
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
    @Binding var customPastaPoint : CGFloat
    
    // 칼로리 관련
    @State var pastaPoint : Float = 1
    
    // Slider Step제어 - v1.1.0 추가
    @State var step : Float = 0.1
    
  
    
    var calories:  Float  {
        get {
            return ceil(pastaPoint * 200)
        }

    }
    // 커스텀데이터 프로필저장
    var calculate = Calculate()
    
    
    var body: some View {
        
        VStack{
            
            Capsule()
                .frame(width: 60, height: 7)
                .foregroundColor(.mainGray)
                .padding()
            
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                
                Button(action: {
                    
              
                }, label: {
                    Image(systemName: "circle")
                        .foregroundColor(.clear)
                        .font(.system(size: 25))
                })
               
                Spacer()
                Text("Custom Settings")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.leading, 20)
                Spacer()
                
                Button(action: {
                    
                    pastaPoint = 1.00
           
                    
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .foregroundColor(.mainRed)
                        .font(.system(size: 25))
                })

            }
            .padding(.horizontal)
          
            
            Divider()
            Spacer()
            
            
        
            
            HStack{
                

               
                        HStack(spacing: 10){
                          
                            VStack(spacing: -7){
                                Text("\(pastaPoint, specifier: "%.2f")")
                                    .bold()
                                    .font(.system(size: 55))
                                Text("Pasta Point")
                                    .font(.system(size: 15))
                                    .bold()
                                Text("(max \(maxPastaPoint, specifier: "%.2f"))")
                                    .bold()
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                                
                            }
                            .offset(CGSize(width: 0.0, height: 10.0))
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            

                            
                            Text("|")
                                 .bold()
                                 .foregroundColor(.gray)
                            
                               

                          
                            VStack(spacing: -7){
                                Text("\(calories, specifier: "%.0f")")
                                    .bold()
                                    .font(.system(size: 55))
                                Text("Calories")
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)

                       
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
            
        
            
            
        }
    
        .foregroundColor(.black)
        

     
        Button(action: {
    
            
            if calculate.userProfileById.isEmpty{
                isCustomViewTapped.toggle()
            }else{
                calculate.saveCustomPastaPoint(pastaPoint: pastaPoint, calories: calories)
                customPastaPoint = CGFloat(calculate.userProfileById.first?.customPastaPoint ?? 1)
                isCustomViewTapped.toggle()
               
                print("The Data Succesfully Saved !\(calculate.userProfileById) \(pastaPoint)")
               
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
    PortionCustom(isCustomViewTapped: .constant(true), customPastaPoint: .constant(1.0))
}
