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
	//var _grid: Grid = Grid(puzzle: Puzzles.hard)
	var _grid: Grid = Grid()
	@EnvironmentObject var _viewRouter: ViewRouter
	
	var body: some View {
		VStack {
			if _viewRouter.getCurrentPage() == Pages.home {
				MenuView()
					.environmentObject(_grid)
					.transition(AnyTransition.asymmetric(
						insertion: AnyTransition.opacity.combined(
							with: .move(edge: .leading)),
						removal: AnyTransition.opacity.combined(
							with: .move(edge: .trailing))
						)
					)
			} else if _viewRouter.getCurrentPage() == Pages.game {
				GameView()
					.transition(.slideAndFadeIn)
					.environmentObject(_grid)
					.environmentObject(_settings)
			} else if _viewRouter.getCurrentPage() == Pages.statistics {
				StatisticsView()
					.transition(.slideAndFadeIn)
			} else if _viewRouter.getCurrentPage() == Pages.strategies {
				StrategiesView()
					.transition(.slideAndFadeIn)
			} else if _viewRouter.getCurrentPage() == Pages.settings {
				SettingsView()
					.transition(.slideAndFadeIn)
					.environmentObject(_settings)
			}
		}
	}
}

extension AnyTransition {
    static var slideAndFadeIn: AnyTransition {
        AnyTransition.asymmetric(
			insertion: AnyTransition.opacity.combined(
				with: .move(edge: .trailing)),
			removal: AnyTransition.opacity.combined(
				with: .move(edge: .leading)
			)
		)
    }
}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
