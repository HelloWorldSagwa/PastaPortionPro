//
//  InAppPurchaseManager.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 6/3/24.
//

import Foundation
import StoreKit
import UIKit

class InAppPurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var products: [SKProduct] = []
    
    private var productRequest: SKProductsRequest?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts(identifiers: [String]) {
        let request = SKProductsRequest(productIdentifiers: Set(identifiers))
        request.delegate = self
        request.start()
        self.productRequest = request
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    // 구매처리
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
//    private func handlePurchase(transaction: SKPaymentTransaction) {
//        // 구매 성공 시 처리 로직
//        let productIdentifier = transaction.payment.productIdentifier
//        // 여기서 productIdentifier를 사용하여 구매된 제품을 식별하고, 필요한 처리를 수행합니다.
//        // 예: 프리미엄 기능 활성화, 사용자 데이터 업데이트 등
//        if productIdentifier == "im.studio5.pastaportionpro.remove_ads" {
//            Settings.premiumAccess = true
//            print("Premium access granted")
//        }
//    }
//    
    
    // 구매복원
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        
//        // 복원이 완료되었을 때 추가 처리
//        Settings.premiumAccess = true
//        print("All transactions have been restored")
//    }
    
    private func handleRestore(transaction: SKPaymentTransaction) {
        // 복원된 제품에 대한 추가 처리
        let productIdentifier = transaction.payment.productIdentifier
        // 여기에서 복원된 제품에 대한 추가 로직을 구현하십시오.
        print("Restored: \(productIdentifier)")
    }
    
    // 구매복원 완료
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 구매 성공 처리
                SKPaymentQueue.default().finishTransaction(transaction)
                Settings.premiumAccess = true
                UserDefaults.standard.set(true, forKey: "premiumAccess")
                
            case .failed:
                // 구매 실패 처리
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // 복원 처리
                SKPaymentQueue.default().finishTransaction(transaction)
                Settings.premiumAccess = true
                UserDefaults.standard.set(true, forKey: "premiumAccess")
                
            default:
                break
            }
        }
    }
}

