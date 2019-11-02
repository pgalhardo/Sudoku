//
//  PauseView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct PauseView: View {
	@ObservedObject var _viewRouter: ViewRouter
	
	init(viewRouter: ViewRouter) {
		_viewRouter = viewRouter
	}
	
	var body: some View {
		VStack {
			// create paused menu, hide grid.......
			Text("paused!")
		}
	}
}
