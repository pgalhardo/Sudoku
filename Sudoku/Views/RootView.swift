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
	var _settings: Settings = Settings()
	@EnvironmentObject var _viewRouter: ViewRouter
	
	var body: some View {
		VStack {
			if _viewRouter.getCurrentPage() == Pages.home {
				MenuView()
					.transition(AnyTransition.asymmetric(
						insertion: AnyTransition.opacity.combined(
							with: .move(edge: .leading)),
						removal: AnyTransition.opacity.combined(
							with: .move(edge: .trailing))
						)
					)
			} else if _viewRouter.getCurrentPage() == Pages.game {
				GameView()
					.transition(.moveAndFadeIn)
					.environmentObject(Grid(puzzle: Puzzles.hard))
					.environmentObject(_settings)
			} else if _viewRouter.getCurrentPage() == Pages.statistics {
				StatisticsView()
					.transition(.moveAndFadeIn)
			} else if _viewRouter.getCurrentPage() == Pages.strategies {
				StrategiesView()
					.transition(.moveAndFadeIn)
			} else if _viewRouter.getCurrentPage() == Pages.settings {
				SettingsView()
					.transition(.moveAndFadeIn)
					.environmentObject(_settings)
			}
		}
	}
}

extension AnyTransition {
    static var moveAndFadeIn: AnyTransition {
        AnyTransition.asymmetric(
			insertion: AnyTransition.opacity.combined(with: .move(edge: .trailing)),
			removal: AnyTransition.opacity.combined(with: .move(edge: .leading))
		)
    }
}
