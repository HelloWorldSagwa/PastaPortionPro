//
//  Welcome.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/24/24.
//

import SwiftUI

struct Welcome: View {
    @State var scale = 1.0
    @State private var isExpanded = false
    @State private var selectedTab : Int = 0
    
    var body: some View {
        VStack{

            
            TabView(selection: $selectedTab){
               
                VStack{
                    MainLogoWithSlogan()
                    Spacer()
                    TutorialDescription()
                    Spacer()
                }
                .tag(0)
                
                VStack{
                    ImageView(image: "Welcome_1", size: 240)
                    
                    TutorialDescription1()
                    Spacer()
                }
                .tag(1)
                
                VStack{
                    ImageView(image: "Welcome_2", size: 240)
                    
                    TutorialDescription2()
                    Spacer()
                }
                .tag(2)
                
                VStack{
                    ImageView(image: "Welcome_3", size: 220)
                    
                    TutorialDescription3()
                    Spacer()
                }
                .tag(3)
                
                VStack{
                    ImageView(image: "Welcome_4", size: 230)
                    
                    TutorialDescription4()
                    Spacer()
                }
                .tag(4)

                
            }
    
            .tabViewStyle(.page(indexDisplayMode: .never))
            .tabViewStyle(PageTabViewStyle())

       
            Spacer()
            TutorialButton(selectedTab: $selectedTab)
            
        }
        .padding()
        
        
        
        
            
 
            
            
            

            
            // 가볍게 던지고, 추가로 설명을 원하는 사람에 한해서 클릭하기
            
            // 0. 본격적으로 사용하기 전에
            // Pasta Portion Pro는 당신이 먹을 파스타의 정량을 찾아주는 앱이에요.
            // 본격적인 이용에 앞서, 폰 화면을 깨끗하게 닦을 수 있는 천과 파스타 면이 필요해요.
            
            // 0.5 앱을 사용하기 전에 프로필을 생성합니다.
            // (1) 프로필 생성은 버튼 하나로 작성 가능합니다.
            // (2) 개인정보 걱정은 하지마세요! 우리는 그 어떤 사용자 정보도 이용하지 않아요.
            
            // 1. 스마트폰 화면을 깨끗하게 닦아 주세요. // 포션 화면에 화면 닦기 버튼 추가 - 안 하기로 함.
            // (1) 아이폰 화면을 잠근 뒤, 화면을 깨끗하게 닦아주세요.
        
            
            // 1. 화면을 닦습니다.
            // (1) Pasta Portion Pro는 식재료와 스마트폰이 직접 접촉을 해야 사용할 수 있습니다.
            // (2) 위생을 위해 사용전 꼭 스마트폰을 닦아주세요.
        
            // 2. 내가 먹을 파스타의 양을 측정합니다.
            // (0) 로그인 후, Portion탭으로 이동해 주세요.
            // (1) 평평한 곳에 폰을 놔 두고, 빨간색 원 안에 스파게티 면을 세워서 놓아주세요.
            // (2) 스파게티를 처음 조리한다면, 1.00 Pasta Point에 맞추고 면을 세로로 놓으면 됩니다.
            // (3) 내가 평소에 요리하는 양을 집어서 측정한다면, 그 양에 맞춰서 빨간색 원을 이동해 주세요.
            // (4) 준비가 다 됐으면, [Save & Start Timer] 버튼을 눌러 화면을 이동합니다.
            
            // 2.5 명심하세요. 1 파스타 포인트는 1인분을 뜻합니다. // 포션화면에 어떤 파스타면인지 적을 수 있게 하는 화면 추가
            // (1) Pasta Point는 Pasta Portion Pro에서 정한 정량이에요.
            // (2) 본인에게 맞는 정량을 선택해야합니다.
            
            // 3. 끓는 물에 파스타를 넣습니다.
            // (1) 파스타 면은 제조사 마다 삶는 시간이 다르기 때문에, 포장지에 있는 삶는 시간을 반드시 확인해주세요.
            // (2) 대개의 경우 6~10분사이, 즉 Al Dente(쫀득함) 정도의 삶기를 권장합니다.
            // (3) 더 부드러운 파스타 면을 원한다면 원하는 시간으로 세팅해주세요.
            // (4) 익힘 정도를 확인 하려면, 완성 2분전에 알림을 받아 볼 수 있는 2 Minutes Alert에 체크를 하세요.
            // (5) Start버튼을 눌러 타이머를 시작합니다.
            
            // 5. Pasta Portion Pro는 면을 삶은 후가 중요해요!
            // (1) 다 삶고 나면 삶은 파스타 면이 어땠는지 체크합니다.
            // (2) 만약, 체크하지 않았어도 괜찮아요! 히스토리에서도 점수를 줄 수 있어요.
            
            // 6. 짜잔! 이제부턴 Home화면과 History기능을 사용할 수 있어요!
            // (1) 평균 값, 최고로 많이 선택한 값, 임의로 설정한 값 등 내가 원하는 값 위주로 홈화면에서 선택 가능해요.
            // (2) 최근에 선택한 값을 선택할 수 있습니다.(최근 5개 값까지 가능)
            
        }
}

#Preview {
    Welcome()
}


private struct TutorialTopImage: View {
    
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



private struct TutorialDescription: View {
    var body: some View {
        VStack(spacing: 30){
    
            Text("Welcome")
                .bold()
                .foregroundColor(.mainRed)
                .font(.system(size: 55))
//                .font(.custom("ZingRustDemo-Base", size: 70))
//                .scaleEffect(logoScale)
//                .opacity(logoOpacity)
//                .onAppear{
//                    withAnimation(Animation.bouncy(duration: 0.8)) {
//                        logoScale = 0.3
//                        logoOpacity = 1.0
//                    }
//                }
            
//            Text("이 앱을 다운로드 해 주셔서 감사합니다!")
//            Text("지금부터 이 앱의 사용법에 대해 설명해 드릴거에요.")
//            Text("준비 되었으면 아래 버튼을 눌러주세요.")
            VStack(spacing: 4){
                Text("Thank you for downloading ") + Text("Pasta Portion Pro").bold().foregroundColor(.mainRed.opacity(1.0)) + Text(".")
                Text("We will now explain how to use this app.")
                Text("If you're ready, please press the button below.")
            }
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5) // 텍스트 배율 조정
            .foregroundColor(.black.opacity(0.7))
            
  
            
            

            
        }
        
    }
}



struct TutorialTopImage1: View {
    var body: some View {

        ImageView(image: "Welcome_1", size: 240)

    }
}


// 1. Clean the screen.
// (1) Pasta Portion Pro requires direct contact between the ingredients and the smartphone.
// (2) For hygiene purposes, please clean your smartphone before use.

private struct TutorialDescription1: View {
    var body: some View {
        VStack(spacing: 30){
            
            VStack{

                Numbering(nubmer: 1)
               
                Text("Clean the Screen")
                    .bold()
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.mainRed)
            }
           
            let bulletListGridItems = [
                GridItem(.fixed(10)),
                GridItem()
            ]
            
            LazyVGrid(columns: bulletListGridItems, alignment: .leading, content: {
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Pasta Portion Pro requires direct contact between the ingredients and the smartphone.", highlight: "Pasta Portion Pro")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("For hygiene purposes, please clean your smartphone before use.")
                }
            })
            .minimumScaleFactor(0.5) // 텍스트 배율 조정
            .foregroundColor(.black.opacity(0.7))
            

            
        }
        
    }
}


// 2. Measure Your Portion.
// (1) Log in and go to the Portion tab.
// (2) Place your phone on a flat surface and stand the spaghetti in the red circle.
// (3) Adjust the red circle to match your desired portion.
// (4) Press [Save & Start Timer] to proceed.

// 2. 내가 먹을 파스타의 양을 측정합니다.
// (0) 로그인 후, Portion탭으로 이동해 주세요.
// (1) 평평한 곳에 폰을 놔 두고, 빨간색 원 안에 스파게티 면을 세워서 놓아주세요.
// (2) 스파게티를 처음 조리한다면, 1.00 Pasta Point에 맞추고 면을 세로로 놓으면 됩니다.
// (3) 내가 평소에 요리하는 양을 집어서 측정한다면, 그 양에 맞춰서 빨간색 원을 이동해 주세요.
// (4) 준비가 다 됐으면, [Save & Start Timer] 버튼을 눌러 화면을 이동합니다.


struct TutorialTopImage2: View {
    var body: some View {
        Spacer()
        ImageView(image: "Welcome_2", size: 240)

    }
}


private struct TutorialDescription2: View {
    var body: some View {
        VStack(spacing: 30){
            
            VStack{
//                Circle()
//                    .overlay{
//
//                        Circle()
//                            .foregroundColor(.mainRed)
//                            .frame(width: 50, height: 50)
//                            .overlay{
//                                Text("2")
//                                    .bold()
//                                    .font(.system(size: 35))
//                                    .minimumScaleFactor(0.5)
//                                    .foregroundColor(.white)
//                            }
//
//                    }
//                    .frame(width: 60, height: 60)
//                    .foregroundColor(.white)
//                    .shadow(radius: 1)
                
                Numbering(nubmer: 2)
               
                Text("Measure Your Portion")
                    .bold()
                    .font(.system(size: 34))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.mainRed)
            }
           
            let bulletListGridItems = [
                GridItem(.fixed(10)),
                GridItem()
            ]
            
            LazyVGrid(columns: bulletListGridItems, alignment: .leading, content: {
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Log in and go to [Portion].", highlight: "[Portion]")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("Place phone flat, stand pasta in red circle.")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Adjust the Pasta Point to match your desired portion.", highlight: "Pasta Point")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Press [Save & Start Timer].", highlight: "[Save & Start Timer]")
                }
            })
            .minimumScaleFactor(0.5) // 텍스트 배율 조정
            .foregroundColor(.black.opacity(0.7))


        }
        
    }
}

//(1) Cooking times vary by brand; check the package.
//(2) Typically, cook for 6-10 minutes for Al Dente.
//(3) Enable the 2 Minutes Alert to get a reminder 2 minutes before completion.
//(4) Press the Start button to begin the timer.


struct TutorialTopImage3: View {
    var body: some View {
        ImageView(image: "Welcome_3", size: 240)
    }
}

private struct TutorialDescription3: View {
    var body: some View {
        VStack(spacing: 30){
            
            VStack{

                Numbering(nubmer: 3)
                
                Text("Boil Pasta with Timer")
                    .bold()
                    .font(.system(size: 34))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.mainRed)
            }
           
            let bulletListGridItems = [
                GridItem(.fixed(10)),
                GridItem()
            ]
            
            LazyVGrid(columns: bulletListGridItems, alignment: .leading, content: {
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("Cooking times vary by brand; check the package.")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("Typically, cook for 6-10 minutes for Al Dente.")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text:"Enable [2 Minutes Alert] to get a reminder 2 minutes before completion.", highlight: "[2 Minutes Alert]")

                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Press [Start] to begin the timer.", highlight: "[Start]")
                }
            })
            .minimumScaleFactor(0.5) // 텍스트 배율 조정
            .foregroundColor(.black.opacity(0.7))

            
        }
        
    }
}

//5. Pasta Portion Pro emphasizes the importance of checking the pasta after boiling!
//   - (1) After boiling, check the texture of the pasta.
//   - (2) Don't worry if you forget to check! You can still rate it in the history section.

struct TutorialTopImage4: View {
    var body: some View {
        Spacer()
        ImageView(image: "Welcome_4", size: 240)
    }
}

private struct TutorialDescription4: View {
    var body: some View {
        VStack(spacing: 30){
            
            VStack{
                Numbering(nubmer: 4)
               
                Text("Rate Your Pasta")
                    .bold()
                    .font(.system(size: 34))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.mainRed)
            }
           
            let bulletListGridItems = [
                GridItem(.fixed(10)),
                GridItem()
            ]
            
            LazyVGrid(columns: bulletListGridItems, alignment: .leading, content: {
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("After boiling, check the texture of the pasta.")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        Text("•")
                        Spacer()
                    })
                    Text("Rate the pasta based on its texture.")
                }
                GridRow {
                    VStack(alignment: .leading, content: {
                        
                        Text("•")
                        Spacer()
                    })
                    HighlightedText(text: "Don't worry if you forget to check! You can still rate it in [History].", highlight: "[History]")
                }
              
            })
            .minimumScaleFactor(0.5) // 텍스트 배율 조정
            .foregroundColor(.black.opacity(0.7))

           
            
        }
        
    }
}




private struct TutorialButton: View {
    @State var isButtonTapped : Bool = false
    @Binding var selectedTab : Int
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(spacing: 20){
            
            HStack{
                ForEach(0..<5){ index in
                    
                    Circle()
                        .frame(width: 5)
                        .foregroundColor(selectedTab == index ? .mainRed : .gray.opacity(0.5))
                    
                }
            }

            
            Button(action: {
                withAnimation {
                    if selectedTab < 4 {
                        selectedTab += 1
                    } else {
                        Settings.firstLogin = false
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }
     
                print(selectedTab)
            }, label: {
                Text(selectedTab == 4 ? "Get Started" : "Next")
                    .modifier(StyledButtonModifier())
            })
        }
       
        
    }
}





//private struct HighlightedText: View {
//    var text: String
//    var highlight: String
//    var highlightColor: Color = .mainRed
//
//    var body: some View {
//        let parts = text.components(separatedBy: highlight)
//        return Text(parts[0])
//            + parts.dropFirst().reduce(Text("")) { partialResult, part in
//                partialResult + Text(highlight)
//                    .foregroundColor(highlightColor)
//                    .fontWeight(.bold)
//                + Text(part)
//            }
//    }
//}


private struct HighlightedText: View {
    var text: String
    var highlight: String
    var highlightColor: Color = .mainRed.opacity(0.7)
    
    var body: some View {
        let translatedText = NSLocalizedString(text, comment: "")
        let parts = "\(translatedText)".components(separatedBy: highlight)
        Text(verbatim: NSLocalizedString(String(describing: parts[0]), comment: ""))
        + parts.dropFirst().reduce(Text("")) { partialResult, part in
            partialResult + Text(highlight)
                .foregroundColor(highlightColor)
                .fontWeight(.bold)
            + Text(part)
        }
    }
}



private struct Numbering: View {
    @State var nubmer : Int
    var body: some View {
        Circle()
            .overlay{
                
                Circle()
                    .foregroundColor(.mainRed)
                    .frame(width: 50, height: 50)
                    .overlay{
                        Text("\(nubmer)")
                            .bold()
                            .font(.system(size: 40))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                    }
                
            }
            .frame(width: 60, height: 60)
            .foregroundColor(.white)
            .shadow(radius: 1)
    }
}


private struct ImageView: View {
    @State var image : String
    @State var size : CGFloat
    var body: some View {
        Spacer()
      
        Image(image)
            .resizable()
            .scaledToFit()
            .clipped()
            .shadow(radius: 10)
            .frame(width: size, height: size)  // 크기를 줄임
       
        Spacer()

    }
}
