//
//  About.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2/6/24.
//

import SwiftUI

struct About: View {
    
    @State private var hideNavigationButton : Bool = false
    let play = Play()
    
    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    var body: some View {
        
        List {
            Section(header: Text("App Version")) {
                Text(appVersion)
            }
            
            Section(header: Text("Company")) {
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                        
                        
                    }, label: {
                        
                        Image("Studio5")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .onTapGesture {
                                play.sound(name: "EasterEggCatSound", type: "mp3")
                            }
                        
                    })
                    
                    Spacer()
                }
                
            }
            
            Section(header: Text("Contact")) {
                
                Link("Email", destination: URL(string: "mailto:studiofiveteam@gmail.com")!)
                Link("Instagram", destination: URL(string: "https://instagram.com/pastaportionpro")!)
            }
            
            Section(header: Text("Privacy Policy")) {
                NavigationLink("View Privacy Policy", destination: PrivacyPolicy())
                    .foregroundColor(.mainRed)
                
            }
            
            Section(header: Text("Our Crew")) {
                Text("Sung (Technical Product Lead)")
                Text("Brena (Chief Graphic Designer)")
                Text("Eva (UI/UX Advisor)")
            }
            
            Section(header: Text("Special Thanks to")) {
                
                Text("Thank you to everyone else who contributed to the app development.")
                Text("Mark (Senior Cahtterbox Officer)")
                Text("Yun (Junior Chatterbox Officer)")
                
                
            }
        }
        
        .navigationTitle("About")
        .tint(Color.mainRed)
        .listStyle(GroupedListStyle())
        
        
    }
    
}


#Preview {
    About()
}
