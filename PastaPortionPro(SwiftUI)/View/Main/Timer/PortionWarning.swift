//
//  PortionWarning.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/29/24.
//

import SwiftUI

struct PortionWarning: View {
  
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: String
    @State private var frameSize : CGFloat = 300
    
    var body: some View {
        
        VStack(spacing: 25){
            Spacer()
            Circle()
                .foregroundColor(.white)
                .frame(width: frameSize - 200)
                .shadow(color:.mainRed, radius: 10)
                .overlay{
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: frameSize - 230))
                        .foregroundColor(.mainRed)
                        .bold()
                }
            
            Text("WARNING")
                .bold()
                .font(.system(size: 30))
                .foregroundColor(.mainRed)
            Divider()
            Text("To use a timer, you have to create the portion first.")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            Divider()
            
            
            Button(action: {
                
                
                presentationMode.wrappedValue.dismiss()
                selectedTab = "Portion"
                
            }, label: {
                Text("Got It")
                    .modifier(StyledButtonModifier())
            })
        }
        .padding()
        

       
    }
      
}

#Preview {
    PortionWarning(selectedTab: .constant("Timer"))
}
