//
//  InAppPurchaseTest.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 6/3/24.
//

import SwiftUI
import StoreKit

// 매달 0.99인지, 아니면 한번에 4.99로 구입할지 ?
// Remove Ads at a one time = 4.99
// Subscribe monthly = 0.99
// 무료 사용자


struct InAppPurchase: View {
    
    
    
    
    var body: some View {
        VStack {
            
            Title()
            
            PurchaseButton()
            
        }
        .padding()
        
    }
    
}

#Preview {
    InAppPurchase()
}


private struct Title : View {
    
    let width = UIScreen.main.bounds.width * 0.8
    let height = UIScreen.main.bounds.height * 0.25
    
    let premiumAccessText : [String] = ["Remove Ads Forever", "Create Unlimited Profiles", "Enhanced History Management", "Get a Premium Badge", "Share Your Purchase with Family"]
    
    
    var body: some View {
        VStack(){
            MainLogo()
                .frame(width: 50)
            PremiumBadge()
                .padding()
            
            VStack{
                Rectangle()
                    .foregroundColor(.mainGray)
                    .cornerRadius(15)
                    .frame(width: width, height: height)
                    .overlay{
                        VStack(alignment: .leading, spacing: 15){
                            
                            ForEach(premiumAccessText, id:\.self){ text in
                                
                                HStack{
                                    Text("✓")
                                        .foregroundColor(.mainRed)
                                 
//                                    Text("\(text)")
                                    
                                    Text(NSLocalizedString(text, comment: ""))
                                    
                                    if text == "Get a Premium Badge" {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.mainRed)
                                            .shadow(radius: 1)
                                            .font(.system(size: 15))
                                    }
                                }
                                .font(.subheadline)
                                .minimumScaleFactor(0.8) // 텍스트 배율 조정
                                .lineLimit(1) // 텍스트를 한 줄로 제한
                                .bold()
                                
                            }
                            
                            
                        }
                        .bold()
                        .padding()
                        
                    }
            }
            
        }
        
    }
}





private struct PurchaseButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var purchaseManager = InAppPurchaseManager()
    
    
    
    let width = UIScreen.main.bounds.width * 0.7
    
    let columns = [
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(purchaseManager.products, id: \.self) { product in
                
                Button(action: {
                    
                    purchaseManager.buyProduct(product)
                    presentationMode.wrappedValue.dismiss()
                    
                    
                }, label: {
                    
                    HStack{
                        Text("Access Now")
                            .foregroundColor(.white)
                            .bold()
                            .minimumScaleFactor(0.8) // 텍스트 배율 조정
                            .lineLimit(1) // 텍스트를 한 줄로 제한
                        
                        Spacer()
                        Text("\(product.priceLocale.currencySymbol ?? "")\(product.price)")
                            .minimumScaleFactor(0.5) // 텍스트 배율 조정
                            .lineLimit(1) // 텍스트를 한 줄로 제한
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                })
                
                .font(.title2)
                .frame(width: width, height: 23)  // 너비 200, 높이 50으로 버튼 크기 조절
                .padding()  // 패딩을 추가하여 버튼 주변에 여백 생성
                .background(Color.mainRed)  // 버튼의 배경색을 파란색으로 설정
                .cornerRadius(15)  // 버튼의 모서리를 둥글게 만드는데 사용되는 코너 반지름 값 설정
                .overlay(RoundedRectangle(cornerRadius: 15)  // 스트로크 추가
                .stroke(Color.black, lineWidth: 0.5))
                .fontWeight(.bold)  // 폰트를 진하게 (Bold)
                
            }
        }
        .padding()
        
        .onAppear {
            purchaseManager.fetchProducts(identifiers: ["im.studio5.pastaportionpro.remove_ads"])
            
        }
    }
}

struct PremiumBadge: View {
    
    var body: some View {
        
        ZStack{
            
            Capsule()
                .foregroundColor(.white)
                .cornerRadius(15.0)
                .frame(width: 300,height: 60)
                .shadow(color: .mainRed ,radius: 2)
            
            
            Capsule()
                .foregroundColor(.mainRed)
                .cornerRadius(15.0)
                .frame(width: 295,height: 55)
                .overlay{
                    Text("GET PREMIUM ACCESS")
                        .minimumScaleFactor(0.9) // 텍스트 배율 조정
                        .lineLimit(1) // 텍스트를 한 줄로 제한
                        .padding(10)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
            
        }
        
        
        
        
    }
}
