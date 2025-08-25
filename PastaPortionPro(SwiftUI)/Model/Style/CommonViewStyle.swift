//
//  CommonViewStyle.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 3/5/24.
//

import SwiftUI

struct CommonViewStyle: View {
    
    @State var start : Bool = false
    @State var endcount : Float = 10
    @State var selectedTab : String = "History"
    @State var isRestarted : Bool = false
    
    var body: some View {
        VStack{
            
            CommonTopStack()
            
            
            ScrollView{
                MainLogoInSlogan(size: 400)
                MainLogoWithSlogan()
                TopStackLogo()
                
                HStack {
                    Text("왼쪽 항목")
                    Divider()
                        .background(Color.gray)
                    Text("오른쪽 항목")
                }
                HStack{
                    InAppIcon(iconName: "arrow.circlepath", iconColor: .white, backgroundColor: .mainRed)
                    InAppIcon(iconName: "minus.circle.fill", iconColor: .white, backgroundColor: .mainRed)
                    InAppIcon(iconName: "arrow.down.square.fill", iconColor: .white, backgroundColor: .mainRed)
                    InAppIcon(iconName: "trash", iconColor: .white, backgroundColor: .mainRed)
                    InAppIcon(iconName: "trash", iconColor: .white, backgroundColor: .mainRed)
                }
                
                
                
                Spacer()
                    .frame(height:50)
                
                Text("DrwaingCircle")
                    .frame(height:30)
                    .bold()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                DrawingCircle(endCount: 40, lineWidth: 25, lineColor: .mainRed, isTextActivated: false)
                
                LoadingView()
                
                
            }
            
            
        }
        
        
        
    }
}

#Preview {
    CommonViewStyle()
}












struct DrawingCircle : View {
    
    @State var start = true
    @State var to : CGFloat = 0
    @State var startCount : Float = 0 // 시작시간
    @State var endCount : Float = 100 // 총 시간 (마지막 시간)
    var circleSize : CGFloat{
        return UIScreen.main.bounds.width - 105
    } // Circle() 사이즈
    @State var lineWidth : CGFloat = 15 // 선 굵기
    @State var lineColor : Color = .blue // 선 색상
    @State var fontColor : Color = .blue // 폰트 색상
    @State var isButtonActivated : Bool = true // 버튼 활성화
    @State var isTextActivated : Bool = true // 숫자 활성화
    
    @State var speed : Double = 0.01
    @State var time = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect() // every: 숫자 -- 뷰 갱신 주기
    
    
    
    var body: some View{
        
        if oldPhoneSupport(){
            ZStack{
                
                VStack{
                    
                    ZStack{
                        
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth + 10, lineCap: .round))
                            .frame(width: circleSize , height: circleSize)
                            .shadow(radius: 1)
                        
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.mainGray, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .frame(width: circleSize, height: circleSize)
                        
                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .frame(width: circleSize, height: circleSize)
                            .rotationEffect(.init(degrees: -90))
                        
                        if isTextActivated == true{
                            
                            VStack{
                                
                                Text("\(self.startCount)")
                                    .font(.system(size: 65))
                                    .fontWeight(.bold)
                                
                                Text("Of \(endCount)")
                                    .font(.title)
                                    .padding(.top)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            .onReceive(self.time) { (_) in
                
                if self.start{
                    
                    if self.startCount != endCount{
                        
                        self.startCount += 1
                        //                    print("\(startCount) seconds")
                        
                        
                        withAnimation(.default){
                            
                            self.to = CGFloat(self.startCount) / CGFloat(endCount)
                        }
                    }
                    else{
                        
                        self.start.toggle()
                        
                    }
                    
                }
                
            }
        }else{
            Circle()
                .stroke(Color.mainRed, lineWidth: 5)
                .frame(width: circleSize - 13, height: circleSize - 13)
                .foregroundColor(.mainGray.opacity(0.1))
                .shadow(radius: 5)
        }
    }
    
}


struct CommonTopStack : View {
    
    @State var logoSize : CGFloat = 40
    @State var title : String = "Funny Cat"
    
    var body: some View {
        HStack{
            Button(action: {
                
            }, label: {
                Image("PPP_LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize)
                    .padding(.leading)
                
            })
            
            Spacer()
            
            
            HStack(spacing: -10){
                
                Text("\(Settings.userEmoji) \(Settings.userName)")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                
            }
            .shadow(radius: 10)
            .offset(CGSize(width: -1.0, height: 0.0))
            
            
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize * 0.65)
                    .foregroundColor(.mainRed)
                    .padding(.trailing)
            })
            
        }
        .padding(.vertical, -10)
    }
}


struct InAppIcon : View {
    
    @State var iconName : String
    @State var iconColor : Color
    @State var backgroundColor : Color
    
    init(iconName : String, iconColor : Color, backgroundColor : Color) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Rectangle()
            .fill(backgroundColor)
            .frame(width: 28, height: 28)
            .cornerRadius(5)
            .overlay{
                Image(systemName: iconName)
                    .bold()
                    .foregroundColor(iconColor)
            }
    }
}

struct TopStackLogo: View {
    @State var logoSize : CGFloat = 40
    @StateObject var presentData = PresentData()
    
    var body: some View {
        ZStack{
            if presentData.premiumAccess{
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.mainRed)
                    .offset(CGSize(width: 25.0, height: -15.0))
                
            }
            
            
            Image("PPP_LOGO")
                .resizable()
                .scaledToFit()
                .frame(width: logoSize)
                .padding(.leading)
        }
        .onAppear(perform: {
            presentData.premiumAccess = Settings.premiumAccess
        })
    }
}

//
//@ViewBuilder func premiumAccessBadge() -> some View {
//    if Settings.premiumAccess{
//        PremiumAccessBadge(height: 37)
//    }
//}


struct PremiumAccessBadge: View {
    
    //    @State var height : CGFloat
    
    var body: some View {
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
        
            .frame(width: 154, height: 20)
    }
}

struct MainLogoWithSlogan: View {
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var isMoved = false
    
    var body: some View {
        VStack(spacing: -70){
            
            MainLogo()
                .scaledToFit()
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
            
                .onAppear {
                    
                    withAnimation(Animation.bouncy(duration: 0.8)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                }
            HStack{
                
                Spacer()
                
                if isMoved{
                    Rectangle()
                        .overlay{
                            Rectangle()
                                .overlay{
                                    Text("PORTION LIKE A PRO.")
                                        .font(.custom("ZingRustDemo-Base", size: 20))
                                        .foregroundColor(.white)
                                }
                                .foregroundColor(.mainRed)
                                .frame(width: 170, height: 28)
                        }
                        .foregroundColor(.white)
                        .frame(width: 175, height: 33)
                        .shadow(radius: 1)
                }
                
                Spacer()
                
                
            }
            
            .onAppear {
                withAnimation(.linear(duration: 0.8)) {
                    self.isMoved = true
                }
            }
        }
        
    }
}


struct MainLogoInSlogan: View {
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var isMoved = false
    @State var size : CGFloat = 330
    
    var body: some View {
        VStack(spacing: -70){
            
            Image("PastaPortionProWithSlogan")
                .resizable()
                .scaledToFit()
                .frame(width: size)  // 크기를 줄임
                .clipped()
            
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
            
                .onAppear {
                    
                    withAnimation(Animation.bouncy(duration: 0.8)) {
                        logoScale = 1.2
                        logoOpacity = 1.0
                    }
                }
            
            
                .onAppear {
                    withAnimation(.linear(duration: 0.8)) {
                        self.isMoved = true
                    }
                }
        }
        
    }
}
