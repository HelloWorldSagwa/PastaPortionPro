//
//  ProfileSwiftUIView.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/02.
//

import SwiftUI



struct ProfileSwiftUIView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var userName: String = ""
    @State private var newUserName : String = MakeRandomName().make()
    @State private var newUserWeight = ""
    @State private var newUserHeight = ""

    @State private var isActive: Bool = false
    
    
    
    
    
    var body: some View {
        
        ScrollView{
            
            VStack(){
                
                
                Image("Profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 225, height: 225)  // 크기를 줄임
                    .clipped()
                
                
                
                VStack(spacing: -20){
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Choose Your Profile")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        
                        ZStack(alignment: .trailing) {
                            TextField("Select Saved Profile", text: $userName)
                                .modifier(StyledTextFieldModifier())
                            
                            Button(action: {
                                print("Button tapped")
                            }) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    .padding()
                    
                    
                    
                    VStack{
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Name")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            
                            ZStack(alignment: .trailing) {
                                
                                TextField("", text: $newUserName, onCommit: {
                                    UIApplication.shared.endEditing()  // 키보드를 숨김
                                })
                                .modifier(StyledTextFieldModifier())
                                
                                Button(action: {
                                    
                                    newUserName = MakeRandomName().make()
                                    
                                }) {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .foregroundColor(.black)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                        .padding()
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 0) {  // 간격을 줄임
                        Text("Height")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        CustomNumberTextField(text: $newUserHeight, placeholder: "Height")
                            .modifier(StyledTextFieldModifier())
                            .keyboardType(.decimalPad)
                    }
                    .padding()  // 하단 패딩만 추가
                    
                    
                    
                    VStack(alignment: .leading, spacing: 0) {  // 간격을 줄임
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(.black)
                        HStack{
                            
                            CustomNumberTextField(text: $newUserWeight, placeholder: "Weight")
                                .modifier(StyledTextFieldModifier())
                                .keyboardType(.decimalPad)
                            
                        }
                        
                    }
                    .padding()  // 하단 패딩만 추가
                    
                }
                
                
                
                                NavigationLink(destination: HomeView()
                                                   .navigationBarHidden(true),
                                                   isActive: $isActive) {
                                        EmptyView()
                                    }
                                    Button(action: {
                
                                        let context = self.managedObjectContext
                                        let userProfile = UserProfile(context: context)
                
                                        userProfile.createdAt = Date()
                                        userProfile.uuid = UUID()
                                        userProfile.name = self.newUserName
                //                        print("\(userProfile.name) Saved!")
                                        userProfile.weight = Double(self.newUserWeight) ?? 0.0
                                        print("\(userProfile.weight) Saved!")
                                        userProfile.height = Double(self.newUserHeight) ?? 0.0
                                        print("\(userProfile.height) Saved!")
                
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Save failed: \(error)")
                                        }
                
                                        // 모든 작업이 완료되면 NavigationLink 활성화
                                        self.isActive = true
                                    }) {
                                        Text("Let's Portion!")
                                            .modifier(StyledButtonModifier())
                                    }
                
                
                
                
                            }
                
                            .padding()
            
            
        }
        
    }
    
}




struct ProfileSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSwiftUIView()
    }
}
