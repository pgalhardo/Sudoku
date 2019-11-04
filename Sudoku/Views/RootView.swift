//
//  RootView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter, Never>()
    
	var _currentPage: Int = Pages.home {
        didSet {
            objectWillChange.send(self)
        }
    }
	
	func getCurrentPage() -> Int {
		return _currentPage
	}
	
	func setCurrentPage(page: Int) {
		_currentPage = page
	}
}

struct RootView: View {
	@EnvironmentObject var _viewRouter: ViewRouter
	var _settings: Settings = Settings()
		
	var body: some View {
		VStack {
			if _viewRouter.getCurrentPage() == Pages.home {
				MenuView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			} else if _viewRouter.getCurrentPage() == Pages.game {
				GameView()
					.transition(AnyTransition.opacity.combined(with: .slide))
					.environmentObject(Grid(puzzle: Puzzles.hard))
					.environmentObject(_settings)
			} else if _viewRouter.getCurrentPage() == Pages.settings {
				SettingsView()
					.transition(AnyTransition.opacity.combined(with: .slide))
					.environmentObject(_settings)
			} else if _viewRouter.getCurrentPage() == Pages.statistics {
				StatisticsView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			} else if _viewRouter.getCurrentPage() == Pages.strategies {
				StrategiesView()
					.transition(AnyTransition.opacity.combined(with: .slide))
			}
		}
	}
}
