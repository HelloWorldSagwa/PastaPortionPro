//
//  LaunchScreen.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 6/12/24.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var isMoved = false
    
    var body: some View {
        VStack(){
            
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
                                    Text("EASILY PORTION IT")
                                        .font(.custom("ZingRustDemo-Base", size: 20))
                                        .foregroundColor(.black.opacity(0.5))
                                }
                                .foregroundColor(.mainRed)
                                .frame(width: 170, height: 28)
                        }
                        .foregroundColor(.white)
                        .frame(width: 175, height: 33)
                        .shadow(radius: 1)
                        .offset(CGSize(width: 0.0, height: -80.0))
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

#Preview {
    LaunchScreen()
}

