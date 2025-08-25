//
//  StopWatchDoneness.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/6/24.
//

import SwiftUI

struct StopWatchDoneness: View {
    var body: some View {
        VStack{
            
            DonenessToolTipCard()
            
        }
        
    }
}

#Preview {
    StopWatchDoneness()
}

struct DonenessToolTipCard: View {
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
                                    
                                    Image(systemName: "timer")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .frame(width: 110)
                                .foregroundColor(.mainRed)
                                .shadow(radius: 1)
                            
                        }
                        Text("Doneness Adjustment")
                            .bold()
                            .foregroundColor(.black.opacity(0.8))
                            .font(.system(size: 25))
                        Divider()
                        Text("Cook most pasta for 8-10 minutes for a chewy texture. For softer pasta, cook longer. Check the package for specific times.")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
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

