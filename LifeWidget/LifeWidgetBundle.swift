//
//  LifeWidgetBundle.swift
//  LifeWidget
//
//  Created by Art3mis on 28/01/25.
//

import WidgetKit
import SwiftUI

@main
struct LifeWidgetBundle: WidgetBundle {
    var body: some Widget {
        LifeWidget()
        LifeWidgetControl()
        LifeWidgetLiveActivity()
    }
}
