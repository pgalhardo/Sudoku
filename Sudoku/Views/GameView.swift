//
//  GameView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct GameView: View {
	@State private var _isPaused: Bool = false
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		VStack {
			TopBarView()
			GridView()
		}
	}
}

struct TopBarView: View {
	@EnvironmentObject var _viewRouter: ViewRouter
	
	var body: some View {
		HStack {
			Button(
				action: {
					withAnimation(.easeIn) {
						self._viewRouter.setCurrentPage(page: Pages.home)
					}
				},
				label: {
					Image(systemName: "stop.fill")
						.resizable()
						.frame(width: Screen.cellWidth / 2,
							   height: Screen.cellWidth / 2)
						.foregroundColor(Colors.MatteBlack)
				}
			)
			
			Spacer()
			TimerView()
			Spacer()
			
			Button(
				action: {
					
				},
				label: {
					Image(systemName: "pause.fill")
						.resizable()
						.frame(width: Screen.cellWidth / 2,
							   height: Screen.cellWidth / 2)
						.foregroundColor(Colors.MatteBlack)
				}
			)
		}
		.padding(.top)
		.padding(.leading)
		.padding(.trailing)
	}
}
