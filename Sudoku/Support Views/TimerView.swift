//
//  TimerView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 31/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct TimerView : View {
    
	@State private var _min: Int = 0
	@State private var _sec: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
		Text(String(format: "%02d:%02d", arguments: [self._min, self._sec]))
			.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
            .onReceive(timer) { _ in
                self._sec += 1
				if self._sec == 60 {
					self._min += 1
					self._sec = 0
				}
            }
    }
}


