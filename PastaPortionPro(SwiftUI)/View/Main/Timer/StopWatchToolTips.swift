//
//  StopWatchToolTips.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/5/24.
//

import SwiftUI

struct StopWatchToolTips: View {
    var body: some View {
        
        VStack{
            
            Spacer()
            
            ToolTipCard()
        
            Spacer()
        }
        
    }
}

#Preview {
    StopWatchToolTips()
}


struct ToolTipCard: View {
    var body: some View {
        ZStack{
            
            
           
            
            Rectangle()
                .frame(width: 300, height: 300)
                .cornerRadius(15)
                .foregroundColor(.white)
                .shadow(radius: 2)
                .overlay{
                    
                    VStack{
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 150)
                                .shadow(radius: 2)
                            Circle()
                                .overlay{
                                    
                                    Image(systemName: "2.brakesignal")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .frame(width: 110)
                                .foregroundColor(.mainRed)
                                .shadow(radius: 1)
                            
                        }
                        Text("2 Minutes Alert")
                            .bold()
                            .foregroundColor(.black.opacity(0.8))
                            .font(.system(size: 30))
                        Divider()
                        Text("Set a timer and recheck the doneness of the pasta \n2 minutes before.")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    }
                    .padding()
                    
                }
            
            Image(systemName: "questionmark.circle.fill")
                .foregroundColor(.mainRed)
                .font(.system(size: 40))
                .offset(CGSize(width: 150.0, height: -150.0))
            
        }
    }
}

