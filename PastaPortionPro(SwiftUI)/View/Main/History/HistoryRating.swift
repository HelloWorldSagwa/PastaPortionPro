//
//  HistoryRatings.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 5/28/24.
//

import SwiftUI
import RealmSwift

struct HistoryRating: View {
    
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var rotation: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    let realm = try! Realm()
   
    
    var body: some View {
        
        let userHistoryRating = try! realm.objects(UserHistory.self).filter("_id == %@", ObjectId(string: Settings.ratingHistory))
       
        VStack(spacing: 30){
          
            Text("How Was the Pasta?")
                .font(.title) // 글자 크기 설정
                .fontWeight(.bold) // 글자 굵기 설정
                .multilineTextAlignment(.center) // 중앙 정렬 설정
            
       
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= rating ? .mainRed : .gray)
                        .onTapGesture {
                            rating = index
                        }
                        .onAppear(perform: {
                            rating = Int(userHistoryRating.first?.ratings ?? 0)
                        })
                }
            }
            .font(.largeTitle)
            
            Button(action: {
                
                try! realm.write{
                    
                    userHistoryRating.first?.ratings = Float(rating)
                    
                }
                
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text(ratingComment(rating: rating))
                    .modifier(StyledButtonModifier())
            })
            .padding(.horizontal, 20)
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

#Preview {
    HistoryRating()
}
