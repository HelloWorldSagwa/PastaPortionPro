//
//  SoundTest.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/8/24.
//

import SwiftUI
import AVFoundation
import WidgetKit
import ActivityKit

struct SoundTest: View {
    var body: some View {
    
        
        ScrollView{
            
            
            ForEach(1000..<1351){newValue in
                
                
                Button(action: {
                    
                    AudioServicesPlaySystemSound(SystemSoundID(newValue))
                }, label: {
                    
                    HStack{
                        Spacer()
                        Text("[\(newValue)]")
                        
                        Spacer()
                            
                    }
                    
                })
            }
            .frame(width: .infinity)
          
        }
        .frame(width: .infinity)
        
        
    }
}

#Preview {
    SoundTest()
}
