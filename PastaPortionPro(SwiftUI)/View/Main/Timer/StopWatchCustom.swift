//
//  StopWatchCustom.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/5/24.
//

import SwiftUI
import RealmSwift

struct StopWatchCustom: View {
    // 바인딩
    @Binding var seconds : Float
    
    // 타이머 관련
    @State var minutes : Float = 8
    @State var isPlusButtonDisabled = false
    @State var isMinusButtonDisabled = false
    @Environment(\.presentationMode) var presentationMode
    
    
    let calculate = Calculate()
    
    var body: some View {
        VStack{
            
   
            VStack{
                
                
                Text(NSLocalizedString(typeOfPasta(minutes: minutes)[0], comment: ""))
                    .font(.system(size: 40))
                    .bold()
                
                Text(NSLocalizedString(typeOfPasta(minutes: minutes)[1], comment: ""))
                    .font(.system(size: 25))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.gray)
                Divider()
            }
            .frame(width: 350)
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        
                        if isPlusButtonDisabled == true {
                            
                            isPlusButtonDisabled = false
                            
                        }
                        
                        if minutes > 3 {
                            minutes -= 0.5
                            
                        }else {
                            isMinusButtonDisabled = true
                        }
                        
                    }, label: {
                        VStack{
                            
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.mainRed)
                                .font(.system(size: 30))
                            
                        }
                        
                    })
                    .opacity(isMinusButtonDisabled ? 0.1 : 1)
                    
                    Spacer()
                    
                    VStack{

                        
                        HStack{
                            Text(timeFormatted(Double(minutes * 60)))
                                .bold()
                                .font(.system(size: 60))
                            
                        }

                        Text("max 20")
                            .foregroundColor(.gray)
                            .bold()
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                    Button(action: {
                        
                        if isMinusButtonDisabled == true {
                            
                            isMinusButtonDisabled = false
                            
                        }
                        
                        if minutes < 20{
                            
                            minutes += 0.5
                            
                        }else{
                            isPlusButtonDisabled = true
                        }
                        
                        
                        
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.mainRed)
                            .font(.system(size: 30))
                    })
                    .opacity(isPlusButtonDisabled ? 0.1 : 1)
                    
                    Spacer()
                    
                    
                }
            
            
                
                
            }
        

            .onAppear(perform: {
                
                minutes = calculate.loadCustomData(search: "minutes")
                if minutes == 0 {
                    minutes = 8
                }
                
            })
        
        
        Button(action: {
            guard let realm = calculate.realm?.thaw() else { return }
            
            do {
                try realm.write{
                    calculate.userProfileById.first?.customMinutes = minutes
                }
            } catch {
                print("Failed to save custom minutes: \(error)")
            }
            
            seconds = minutes * 60
            
            print("Custom Minutes Saved! : \(String(describing: calculate.userProfileById.first?.customMinutes))")
            
            presentationMode.wrappedValue.dismiss()
            
            
        }, label: {
                Text("Save")
                .modifier(StyledButtonModifier())
            })
        
        .padding(.top, 20)
        .padding(.horizontal, 20)
            
    }
    
    
  
    
    private func typeOfPasta(minutes: Float) -> [String]{
        
        if minutes <= 10{
            
            return ["Chewy", "Al Dente"]
            
            
        } else if minutes <= 15{
            
            return ["Tender", "Cottura"]
            
            
        }
        else{
            
            return ["Soft", "Ben Cotto"]
            
            
        }
    }
    
}



#Preview {
    StopWatchCustom(seconds: .constant(480))
}
