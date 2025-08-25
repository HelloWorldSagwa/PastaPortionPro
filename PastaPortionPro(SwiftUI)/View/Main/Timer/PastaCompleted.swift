//
//  PastaCompleted.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 2023/09/19.
//

import SwiftUI
import RealmSwift

//UUID로드 돼야함
//UUID에 맞는 별점 매겨야 됨


struct PastaCompleted: View {
    
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var rotation: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        
        VStack{
            
            Image("PastaCompleted")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(height: 325)
                .rotation3DEffect(
                    .degrees(rotation),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: 0.5)) {
                        rotation = 360
                    }
                }
            
            Spacer()
                .frame(height: 50)
            
            VStack{
                
                
                Text("Your Pasta Is Ready.\nDo You Like It?")
                    .font(.title) // 글자 크기 설정
                    .fontWeight(.bold) // 글자 굵기 설정
                    .multilineTextAlignment(.center) // 중앙 정렬 설정
                
                Spacer()
                    .frame(height: 15)
                
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index <= rating ? .mainRed : .gray)
                            .onTapGesture {
                                rating = index
                            }
                    }
                }
                .font(.largeTitle)
    
                
                
            }
            
            Spacer()
                .frame(height: 40)
            
            
            Button(action: {
                
                stopWatchDataSave()
                presentationMode.wrappedValue.dismiss()
                
                Settings.completeId = "" // 컴플리트 id초기화
                
                
                
            }, label: {
                Text(ratingComment(rating: rating))
                    .modifier(StyledButtonModifier())
            })
            
        }
        .padding()
        
    }
    
    private func stopWatchDataSave(){
        let realm = try! Realm()
        @ObservedResults(UserHistory.self) var userHistory
        
        let userHistoryByHistoryId = userHistory.where{
            try! $0._id == ObjectId(string: Settings.completeId)
        }
        
        try! realm.write{
            
            userHistoryByHistoryId.first?.ratings = Float(rating)
            print("rating Saved! \(String(describing: userHistoryByHistoryId.first?.cookMinutes))")
            
        }


    }
    
    
}


private func ratingComment(rating : Int) -> String{
    
    var result : String = "Rate And Tap"
    
    if rating == 5{
        result = "Best"
    } else if rating == 4{
        result = "Very Good"
    }else if rating == 3{
        result = "Good"
    }else if rating == 2{
        result = "Fair"
    }else if rating == 1{
        result = "Poor"
    }
    
    return result
    
}



struct PastaCompleted_Previews: PreviewProvider {
    static var previews: some View {
        PastaCompleted()
    }
}
