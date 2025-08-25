//
//  TwoMinutesAlert.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/8/24.
//

import SwiftUI

struct StopWatchTwoMinutesAlert: View {
    
    @State var timer : Timer? = nil
    @State var seconds : Float = 10
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        
        VStack{
            Spacer().frame(height: 50) // v1.1.0추가
         
            ZStack{
                let rectangleHeight = UIScreen.main.bounds.height * 0.3
                let circleSize = rectangleHeight * 0.5
                Rectangle()
                    .frame(height: rectangleHeight)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .overlay{
                        
                        VStack{
                            if oldPhoneSupport(){
                                ZStack{
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: circleSize)
                                        .shadow(radius: 2)
                                        
                                    Circle()
                                        .overlay{
                                            
                                            Image(systemName: "2.brakesignal")
                                                .font(.largeTitle)
                                                
                                                .foregroundColor(.white)
                                                .bold()
                                        }
                                        .frame(width: circleSize - 40)
                                        
                                        .foregroundColor(.mainRed)
                                        .shadow(radius: 1)
                                    
                                }
                            }else{
                                Spacer()
                            }
                          
                            Text("2 Minutes Alert")
                                .bold()
                                .foregroundColor(.black.opacity(0.8))
                                .font(.largeTitle)
                            Divider()
                            Text("2 minutes until the pasta is done! Check the doneness! This message will close in \(seconds, specifier: "%.0f") seconds.")
                                .lineLimit(3)
                                .bold()
                                .foregroundColor(.black)
                                
                        }
                        .padding()
                        
                    }
                
                Circle()
                    .frame(width: 45)
                    .foregroundColor(.mainRed)
                    .shadow(radius: 2)
                    .overlay{
                        
                        Text("\(seconds, specifier: "%.0f")")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                        
                            .onAppear(perform: {
                                timerStart()
                            })
                            .onChange(of: seconds, perform: { value in
                                if value == 0{
                                    
                                    close()
                                }
                            })
           
                    }
                    .offset(CGSize(width: rectangleHeight / 1.65, height: rectangleHeight / -2))

            }
            
            Button(action: {
                
                close()
                
            }, label: {
                
                Text("Close")
                    .font(.system(size: 25))  // 폰트 사이즈 설정
                    .foregroundColor(Color.white)  // 버튼의 전경색을 하얀색으로 설정
                    .frame(width: 290, height: 25)  // 너비 200, 높이 50으로 버튼 크기 조절
                    .padding()  // 패딩을 추가하여 버튼 주변에 여백 생성
                    .background(Color.mainRed)  // 버튼의 배경색을 파란색으로 설정
                    .cornerRadius(10)  // 버튼의 모서리를 둥글게 만드는데 사용되는 코너 반지름 값 설정
                    .overlay(RoundedRectangle(cornerRadius: 10)  // 스트로크 추가
                        .stroke(Color.black, lineWidth: 0.5))
                    .fontWeight(.bold)  // 폰트를 진하게 (Bold)
                

               
            })
            .padding(.vertical)
        }
        .padding(40)
        
       
        
        
     
    }
    
    private func close(){
        
        presentationMode.wrappedValue.dismiss()
        
    }
    private func timerStart(){
        
        timer?.invalidate()

        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
            if self.seconds > 0{
                self.seconds -= 1
            }else{
                
                timer.invalidate()
                
            }
        }

    }
}
#Preview {
    StopWatchTwoMinutesAlert()
}
