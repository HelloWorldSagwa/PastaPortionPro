//
//  PrivacyPolicy.swift
//  PastaPortionPro
//
//  Created by SungHyun Kim on 6/19/24.
//

import SwiftUI

struct PrivacyPolicy: View {
    @State private var privacyPolicyText: String = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ScrollView {
            Text(
                //"""
                //Last updated: June 28, 2024
                //
                //1. Data Collection
                //
                //Our app does not collect personal data directly from users.
                //
                //2. Ad Networks
                //
                //Our app uses Google AdMob to provide personalized ads. Google AdMob may collect the following information:
                //
                //•    Device identifiers (e.g., Advertising ID)
                //•    IP address
                //•    Location information
                //•    App usage data
                //
                //This information is used to provide a better ad experience. You can review Google AdMob’s privacy policy here:
                //
                //https://policies.google.com/privacy
                //
                //3. Data Protection
                //
                //While we do not collect personal data directly, third-party ad networks may collect data. Please refer to their privacy policies for more details.
                //
                //4. Cookies and Tracking Technologies
                //
                //Our app may use cookies and similar tracking technologies via third-party ad networks.
                //
                //5. User Rights
                //
                //Users have the right to access, modify, and delete their personal data, as well as to restrict or object to its processing. Specific rights vary by region:
                //
                //•    California (CCPA): Right to know, access, and delete personal data.
                //•    EU (GDPR): Right to access, rectify, erase, restrict processing, data portability, and object to processing.
                //•    South Korea: Right to withdraw consent, access, correct, and delete personal data.
                //•    Japan: Right to access, correct, and delete personal data.
                //•    China: Right to access, correct, delete personal data, and withdraw consent.
                //
                //To exercise these rights, contact us.
                //
                //6. Changes to this Policy
                //
                //This policy may change. Changes will be posted on this page and, if significant, notified through the app.
                //
                //For questions or concerns about this policy, contact us at:
                //
                //•    email: studiofiveteam@gmail.com
                //
                //"""
                """

Last updated: July 7, 2024

    1.    Data Collection

Our app uses Firebase to enhance functionality and user experience. While we do not collect personal data directly, Firebase may collect data as follows:

•    Device identifiers (e.g., Advertising ID)
•    IP address
•    Location information
•    App usage data
•    Analytics data to improve app performance

This data is used to enhance app functionality and optimize user experience. Detailed information on the data collected by Firebase can be found in their privacy policy here: Firebase Privacy Policy.

    2.    Ad Networks

Our app uses Google AdMob to provide personalized ads. Google AdMob may collect the following information:

•    Device identifiers (e.g., Advertising ID)
•    IP address
•    Location information
•    App usage data

This information is used to provide a better ad experience. You can review Google AdMob’s privacy policy here: Google AdMob Privacy Policy.

    3.    Data Protection

We ensure that all data collected through Firebase and third-party ad networks are handled in accordance with data protection laws. Please refer to their privacy policies for more details.

    4.    Cookies and Tracking Technologies

Our app may use cookies and similar tracking technologies via third-party ad networks and Firebase.

    5.    User Rights

Users have the right to access, modify, and delete their personal data, as well as to restrict or object to its processing. Specific rights vary by region:

•    California (CCPA): Right to know, access, and delete personal data.
•    EU (GDPR): Right to access, rectify, erase, restrict processing, data portability, and object to processing.
•    South Korea: Right to withdraw consent, access, correct, and delete personal data.
•    Japan: Right to access, correct, and delete personal data.
•    China: Right to access, correct, delete personal data, and withdraw consent.

To exercise these rights, contact us.

    6.    Changes to this Policy

This policy may change. Changes will be posted on this page and, if significant, notified through the app.

For questions or concerns about this policy, contact us at:

•    email: studiofiveteam@gmail.com
"""
                
                
            )
            
            .navigationTitle("Privacy Policy")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
                
            })
            .padding()
        }
        
    }
    
}

#Preview {
    PrivacyPolicy()
}
