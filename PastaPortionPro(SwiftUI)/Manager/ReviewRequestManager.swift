//
//  ReviewRequestManager.swift
//  PastaPortionPro
//
//  Created for version 1.3 review request
//

import SwiftUI
import StoreKit
import MessageUI

class ReviewRequestManager: ObservableObject {
    static let shared = ReviewRequestManager()
    
    @Published var showEmotionCheck = false
    @Published var showReviewRequest = false
    @Published var showFeedbackForm = false
    
    private init() {}
    
    // 1.3 이전 사용자 체크 및 리뷰 요청
    func checkAndRequestReview() {
        // 이미 1.3에서 요청했는지 확인
        let hasRequestedReview = UserDefaults.standard.bool(forKey: "hasRequestedReviewFor1.3")
        
        if hasRequestedReview {
            return // 이미 요청했으면 종료
        }
        
        // UserDefaults에서 이전 버전 확인
        let lastVersion = UserDefaults.standard.string(forKey: "lastAppVersion") ?? "1.0"
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.3"
        
        // 처음 실행이거나 1.3 이전 버전 사용자면 즉시 리뷰 요청
        if lastVersion < "1.3" {
            DispatchQueue.main.async {
                self.showEmotionCheck = true
                UserDefaults.standard.set(true, forKey: "hasRequestedReviewFor1.3")
                UserDefaults.standard.set(currentVersion, forKey: "lastAppVersion")
            }
        }
    }
    
    // 리뷰 응답 로깅 (UserDefaults 사용)
    func logReviewResponse(response: String) {
        UserDefaults.standard.set(response, forKey: "reviewResponse1.3")
        UserDefaults.standard.set(Date(), forKey: "reviewResponseDate1.3")
    }
}

// SwiftUI Views
struct ReviewRequestView: View {
    @StateObject private var manager = ReviewRequestManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        EmptyView()
            .alert(NSLocalizedString("🍝 Worth the Wait?", comment: "Review request title"), isPresented: $manager.showEmotionCheck) {
                Button(NSLocalizedString("😊 Love it!", comment: "Positive response"), role: .none) {
                    manager.showEmotionCheck = false
                    manager.showReviewRequest = true
                    manager.logReviewResponse(response: "positive")
                }
                Button(NSLocalizedString("😐 Not really", comment: "Negative response"), role: .none) {
                    manager.showEmotionCheck = false
                    manager.showFeedbackForm = true
                    manager.logReviewResponse(response: "negative")
                }
            } message: {
                Text(NSLocalizedString("""
                Dynamic Island is finally here!
                Cook with more convenience now
                
                How do you like it?
                """, comment: "Review request message"))
            }
            .alert(NSLocalizedString("Glad you love it! 😊", comment: "Positive review title"), isPresented: $manager.showReviewRequest) {
                Button(NSLocalizedString("⭐ Write Review", comment: "Write review button"), role: .none) {
                    requestAppStoreReview()
                    manager.logReviewResponse(response: "wrote_review")
                }
                Button(NSLocalizedString("Later", comment: "Later button"), role: .cancel) {
                    manager.logReviewResponse(response: "review_later")
                }
            } message: {
                Text(NSLocalizedString("""
                Help other pasta lovers
                discover this app with
                just one quick review
                
                (Even super short is OK!)
                """, comment: "Review request positive message"))
            }
            .alert(NSLocalizedString("Sorry to hear that 😔", comment: "Negative review title"), isPresented: $manager.showFeedbackForm) {
                Button(NSLocalizedString("📧 Send Feedback via Email", comment: "Send feedback button"), role: .none) {
                    sendFeedbackEmail()
                    manager.logReviewResponse(response: "sent_email")
                }
                Button(NSLocalizedString("Close", comment: "Close button"), role: .cancel) {
                    manager.logReviewResponse(response: "feedback_dismissed")
                }
            } message: {
                Text(NSLocalizedString("""
                Please let us know what's
                bothering you and we'll improve
                """, comment: "Feedback request message"))
            }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func sendFeedbackEmail() {
        let email = "studiofiveteam@gmail.com"
        let subject = "[PastaPortionPro 1.3] 피드백"
        let body = """
        앱 버전: 1.3
        기기: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        
        피드백:
        
        """
        
        // URL 인코딩
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // mailto URL 생성
        if let url = URL(string: "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // 이메일 앱이 없으면 클립보드에 복사
                UIPasteboard.general.string = email
                print("Email address copied to clipboard: \(email)")
            }
        }
    }
}

// UIKit ViewController용 (필요한 경우)
extension ReviewRequestManager {
    func presentReviewRequest(from viewController: UIViewController) {
        // Step 1: Emotion Check
        let emotionAlert = UIAlertController(
            title: NSLocalizedString("🍝 Worth the Wait?", comment: "Review request title"),
            message: NSLocalizedString("""
            Dynamic Island is finally here!
            Cook with more convenience now
            
            How do you like it?
            """, comment: "Review request message"),
            preferredStyle: .alert
        )
        
        emotionAlert.addAction(UIAlertAction(title: NSLocalizedString("😊 Love it!", comment: "Positive response"), style: .default) { _ in
            self.showReviewRequestAlert(from: viewController)
            self.logReviewResponse(response: "positive")
        })
        
        emotionAlert.addAction(UIAlertAction(title: NSLocalizedString("😐 Not really", comment: "Negative response"), style: .default) { _ in
            self.showFeedbackAlert(from: viewController)
            self.logReviewResponse(response: "negative")
        })
        
        viewController.present(emotionAlert, animated: true)
        UserDefaults.standard.set(true, forKey: "hasRequestedReviewFor1.3")
    }
    
    private func showReviewRequestAlert(from viewController: UIViewController) {
        let reviewAlert = UIAlertController(
            title: NSLocalizedString("Glad you love it! 😊", comment: "Positive review title"),
            message: NSLocalizedString("""
            Help other pasta lovers
            discover this app with
            just one quick review
            
            (Even super short is OK!)
            """, comment: "Review request positive message"),
            preferredStyle: .alert
        )
        
        reviewAlert.addAction(UIAlertAction(title: NSLocalizedString("⭐ Write Review", comment: "Write review button"), style: .default) { _ in
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            self.logReviewResponse(response: "wrote_review")
        })
        
        reviewAlert.addAction(UIAlertAction(title: NSLocalizedString("Later", comment: "Later button"), style: .cancel) { _ in
            self.logReviewResponse(response: "review_later")
        })
        
        viewController.present(reviewAlert, animated: true)
    }
    
    private func showFeedbackAlert(from viewController: UIViewController) {
        let feedbackAlert = UIAlertController(
            title: NSLocalizedString("Sorry to hear that 😔", comment: "Negative review title"),
            message: NSLocalizedString("""
            Please let us know what's
            bothering you and we'll improve
            """, comment: "Feedback request message"),
            preferredStyle: .alert
        )
        
        feedbackAlert.addAction(UIAlertAction(title: NSLocalizedString("📧 Send Feedback via Email", comment: "Send feedback button"), style: .default) { _ in
            self.openEmailClient()
            self.logReviewResponse(response: "sent_email")
        })
        
        feedbackAlert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Close button"), style: .cancel) { _ in
            self.logReviewResponse(response: "feedback_dismissed")
        })
        
        viewController.present(feedbackAlert, animated: true)
    }
    
    private func openEmailClient() {
        let email = "studiofiveteam@gmail.com"
        let subject = "[PastaPortionPro 1.3] 피드백"
        let body = """
        앱 버전: 1.3
        기기: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        
        피드백:
        
        """
        
        // URL 인코딩
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // mailto URL 생성
        if let url = URL(string: "mailto:\(email)?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // 이메일 앱이 없으면 클립보드에 복사
                UIPasteboard.general.string = email
                print("Email address copied to clipboard: \(email)")
            }
        }
    }
}