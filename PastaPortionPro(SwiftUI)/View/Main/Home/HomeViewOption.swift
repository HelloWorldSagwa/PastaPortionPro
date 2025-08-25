//
//  HomeViewOption.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/24/24.
//

import SwiftUI

struct HomeViewOption: View {
    
    @Binding var selectedLink : String
    
    @State private var option : String = "Average"
    @State private var options = ["Custom", "Average", "Most"]
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(){
            
            MainLogo()
            Text("Set First Home Screen Option")
                .bold()
                .font(.system(size: 25))
                .foregroundColor(.black)
            Divider()
            Text("Please set the option you will first see on the home screen.")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.gray)
            
            
           
            Picker("options", selection: $option){
                ForEach(options, id:\.self){ option in
                    
               
                        Text("\(Text(NSLocalizedString(option, comment: "")))").tag(option)
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(option == self.option ? .mainRed : .gray)
                    
                    
                
                }
                .onAppear(perform: {
                    option = Settings.homeViewOption
                })
              
            }
            .pickerStyle(.wheel)
            
            Button(action: {
                
                Settings.homeViewOption = option
                selectedLink = option
                print(selectedLink)
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
    HomeViewOption(selectedLink: .constant(""))
}
