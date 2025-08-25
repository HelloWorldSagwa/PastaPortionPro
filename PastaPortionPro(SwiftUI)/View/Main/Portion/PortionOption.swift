//
//  PortionOption.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/24/24.
//

import SwiftUI

struct PortionOption: View {
    
    @Binding var changePtCal : Bool
    
    @State private var option : String = "Pasta Point"
    @State private var options = ["Pasta Point", "Calories"]
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(){
            
            MainLogo()
            Text("Select Highlighted Data")
                .bold()
                .font(.system(size: 25))
                .foregroundColor(.black)
            Divider()
            Text("Please select the data to highlight on the screen.")
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
                    if Settings.portionViewOption{
                        option = options[1]
                    }else{
                        option = options[0]
                    }
                })
              
            }
            .pickerStyle(.wheel)
            
            Button(action: {
                
             
                if option == "Pasta Point"{
                    Settings.portionViewOption = false
                    changePtCal = false
                }else{
                    Settings.portionViewOption = true
                    changePtCal = true
                }
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
    PortionOption(changePtCal: .constant(true))
}
