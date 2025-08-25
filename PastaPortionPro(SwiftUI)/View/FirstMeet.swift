//
//  FirstMeet.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 6/17/24.
//

import SwiftUI

struct FirstMeet: View {
    
    @Binding var firstMeet : Bool
    
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var isMoved = false
    
    @State private var slideIn1 = false
    @State private var slideIn2 = false
    @State private var slideIn3 = false
    @State private var slideIn4 = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Starting\nPasta Portion Pro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
                .foregroundColor(.mainRed)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .onAppear {
                    
                    withAnimation(Animation.bouncy(duration: 0.8)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                }
            
            
            
            VStack(alignment: .leading, spacing: 30) {
                FeatureView(icon: "target", title: "Accurate Pasta Portion Calculation", description: "Use Pasta Points to measure the exact amount of pasta you need. No more guessing!", slideIn: $slideIn1, dispatchTime: 0)
                
                FeatureView(icon: "rectangle.3.group", title: "Smart Dashboard for Easy Management", description:  "Manage everything easily with our smart dashboard. It's clear and straightforward.", slideIn: $slideIn2, dispatchTime: 0.15)
                
                FeatureView(icon: "clock.arrow.circlepath", title: "Powerful History Feature", description: "Track all your cooking records in one place: averages, most selected options, calories, cooking time, and Pasta Points.", slideIn: $slideIn3, dispatchTime: 0.3)
                
//                FeatureView(icon: "nosign", title: "No User Data Collection", description: "We do not collect any user data. Your privacy is our top priority.", slideIn: $slideIn4, dispatchTime: 0.45)

            }
            
            
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
            
            Spacer()
            Button(action: {
                
                firstMeet = false
                Settings.firstMeet = false
                
            }) {
                Text("Continue")
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mainRed)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
        .onAppear {
            
            withAnimation(Animation.bouncy(duration: 0.8)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
        }
        
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String
    
    @Binding var slideIn : Bool
    var dispatchTime : Double
    
    
    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: icon)
                .font(.system(size: 40))
            
                .frame(width: 40, height: 40)
                .foregroundColor(.mainRed)
            
            VStack(alignment: .leading, spacing: 5) {
//                Text(title)
                
                Text(verbatim: NSLocalizedString(String(describing: title), comment: ""))
                    .font(.headline)
                    .fontWeight(.bold)
                
                HighlightedText(text: description, highlight: "Pasta Point")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .offset(x: slideIn ? 0 : -UIScreen.main.bounds.width) // Slide In
        
        
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                withAnimation(.bouncy(duration: 0.7)) {
                    self.slideIn.toggle()
                }
            }
            
        }
    }
    
}

struct FirstMeet_Previews: PreviewProvider {
    static var previews: some View {
        FirstMeet(firstMeet: .constant(true))
    }
}




private struct HighlightedText: View {
    var text: String
    var highlight: String
    var highlightColor: Color = .mainRed.opacity(0.7)
    
    var body: some View {
        let translatedText = NSLocalizedString(text, comment: "")
        let parts = "\(translatedText)".components(separatedBy: highlight)
        Text(verbatim: NSLocalizedString(String(describing: parts[0]), comment: ""))
        + parts.dropFirst().reduce(Text("")) { partialResult, part in
            partialResult + Text(highlight)
                .foregroundColor(highlightColor)
                .fontWeight(.bold)
            + Text(part)
        }
    }
}
