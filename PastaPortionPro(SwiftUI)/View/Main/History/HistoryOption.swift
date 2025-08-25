//
//  HIstoryOption.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/24/24.
//

import SwiftUI

struct HistoryOption: View {
    
    @State private var option : String = "Fold"
    @State private var options = ["Fold", "Unfold"]
    
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        VStack(){
            
            MainLogo()
            Text("History Page View Options")
                .bold()
                .font(.system(size: 25))
                .foregroundColor(.black)
            Divider()
            Text("Summary when folded or all information when unfolded.")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.gray)
            
            
           
            Picker("options", selection: $option){
                ForEach(options, id:\.self){ option in
                    
               
                        Text("\(option)").tag(option)
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(option == self.option ? .mainRed : .gray)
                    
                    
                
                }
                .onAppear(perform: {
                    option = Settings.historyViewOption
                })
              
            }
            .pickerStyle(.wheel)
            
            Button(action: {
                
                Settings.historyViewOption = option
                presentationMode.wrappedValue.dismiss()
    
                
            }, label: {
                Text("Save")
                    .modifier(StyledButtonModifier())
            })
        }
        .padding()
    }
}

#Preview {
    HistoryOption()
}
