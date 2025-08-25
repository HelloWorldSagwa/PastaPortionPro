//
//  IntroSwiftUIView.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/02.
//

import SwiftUI

struct IntroSwiftUIView: View {
    var body: some View {
        NavigationView{
            VStack{
                Image("PPP_LOGO")
                    .resizable()  // 크기를 조절할 수 있게 만듭니다.
                    .aspectRatio(contentMode: .fit) // 비율을 유지하면서 적절히 크기를 조절합니다.
                    .frame(width: 350, height: 350) // 프레임의 크기를 지정합니다.
                    .clipped()  // 프레임을 벗어나는 부분을 잘라냅니다.
                VStack{
                    
                    NavigationLink(destination: ProfileSwiftUIView()){
                        
                        Text("Choose / Make Profile")
                        .modifier(StyledButtonModifier())
                        
                    }
                    
                    
                    Spacer()
                        .frame(height: 50)
                    
                    ZStack{
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 270)
                        
                        Text(" OR YOU CAN START WITH ")
                            .background(Color.white)
                            .font(.system(size: 10))
                    }
                    
                    
                    
                    Button("Annonymous"){
                    }
                    .modifier(StyledButtonModifier())
                    
                    Button("Last Profile"){
                    }
                    .modifier(StyledButtonModifier())
                    
                }
                
            }
            
        }
        
    }
    
}

struct IntroSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        IntroSwiftUIView()
    }
}
