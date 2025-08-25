//
//  GoogleAdView.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 5/30/24.
//

import SwiftUI
import GoogleMobileAds
import AdSupport
import AppTrackingTransparency

struct GoogleAdView: View {
    @StateObject private var interstitialAdManager = InterstitialAdsManager()
  
    
    var body: some View {
        
        admobBanner()
        
        
        
        Button(action: {
            
            interstitialAdManager.displayInterstitialAd()
            
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        .onAppear {
            
            interstitialAdManager.loadInterstitialAd()
          
        }
        .padding()
        .disabled(!interstitialAdManager.interstitialAdLoaded)
           
    }
}

#Preview {
    GoogleAdView()
}

@ViewBuilder func admobBanner() -> some View {
    if !Settings.premiumAccess{
        GADBanner().frame(height: GADAdSizeBanner.size.height)
    }
}


// 배너광고

struct GADBanner: UIViewControllerRepresentable {
    
    let googleAdBannerID : String = "ca-app-pub-1788255212204158/7837161133"
    let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)

    
    func makeUIViewController(context: Context) -> some UIViewController {
       

        let view = GADBannerView(adSize: bannerSize)
        let viewController = UIViewController()
        view.adUnitID = googleAdBannerID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)

        let request = GADRequest()
        
        print("ATTrackingManager.trackingAuthorizationStatus : \(ATTrackingManager.trackingAuthorizationStatus)")
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined ||
               ATTrackingManager.trackingAuthorizationStatus == .denied {
                print("비개인 맞춤광고 ON")
                // 비개인 맞춤형 광고 설정
                let extras = GADExtras()
                extras.additionalParameters = ["npa": "1"]
                request.register(extras)
            }
        }
        
        view.load(request)
        
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}




// 전면광고

// 내아이디 ca-app-pub-1788255212204158/8592369834
// 테스트아이디 ca-app-pub-3940256099942544/4411468910
class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
    // Properties
    @Published var interstitialAdLoaded:Bool = false
    var interstitialAd:GADInterstitialAd?
    let googleAdInterstitialID : String = "ca-app-pub-1788255212204158/8592369834"
    
    override init() {
        super.init()
    }
    
    // Load InterstitialAd
    func loadInterstitialAd(){
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["6513cc71ddab1a210b1508951afcce48"]
        GADInterstitialAd.load(withAdUnitID: googleAdInterstitialID, request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error = error{
                print("🔴: \(error.localizedDescription)")
                self.interstitialAdLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.interstitialAdLoaded = true
            self.interstitialAd = add
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    // Display InterstitialAd
    func displayInterstitialAd(){
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let root = windowScene?.windows.first?.rootViewController else {
            return
        }
        if let add = interstitialAd{
            add.present(fromRootViewController: root)
            self.interstitialAdLoaded = false
        }else{
            print("🔵: Ad wasn't ready")
            self.interstitialAdLoaded = false
            self.loadInterstitialAd()
        }
    }
    
    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🟡: Failed to display interstitial ad")
        self.loadInterstitialAd()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🤩: Displayed an interstitial ad")
        self.interstitialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("😔: Interstitial ad closed")
    }
}
