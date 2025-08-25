//
//  newViewTest.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by SungHyun Kim on 4/21/24.
//

import SwiftUI

struct newViewTest: View {
    @State private var showModal = false
       @State private var isAllowedToDismiss = false

       var body: some View {
           Button("Show Modal") {
               showModal = true
           }
           .fullScreenCover(isPresented: $showModal) {
               ModalView(isAllowedToDismiss: $isAllowedToDismiss) {
                   showModal = false
               }
           }
       }
}

struct ModalView: View {
    @Binding var isAllowedToDismiss: Bool
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("This is a modal view.")
            Toggle("Allow Dismiss", isOn: $isAllowedToDismiss)
            Button("Dismiss") {
                if isAllowedToDismiss {
                    onDismiss()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    newViewTest()
}
