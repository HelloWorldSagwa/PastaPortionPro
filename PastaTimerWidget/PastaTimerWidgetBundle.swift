//
//  PastaTimerWidgetBundle.swift
//  PastaTimerWidget
//
//  Created by SungHyun Kim on 8/25/25.
//

import WidgetKit
import SwiftUI

@main
struct PastaTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        PastaTimerWidget()
        PastaTimerWidgetControl()
        PastaTimerWidgetLiveActivity()
    }
}
