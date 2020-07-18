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
	
	var currentPage: Int = Pages.home {
		didSet {
			objectWillChange.send(self)
		}
	}
	
	func getCurrentPage() -> Int {
		return self.currentPage
	}
	
	func setCurrentPage(page: Int) -> Void {
		self.currentPage = page
	}
	
	func currentlyAt(page: Int) -> Bool {
		return self.currentPage == page
	}
}

struct RootView: View {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	private var grid: Grid = Grid()
	private var settings: Settings = Settings()
	
	var body: some View {
		VStack {
			if viewRouter.currentlyAt(page: Pages.home) {
				MenuView()
					.environmentObject(grid)
					.transition(AnyTransition.asymmetric(
						insertion: AnyTransition.opacity.combined(
							with: .move(edge: .leading)),
						removal: AnyTransition.opacity.combined(
							with: .move(edge: .trailing))
						)
				)
			} else if viewRouter.currentlyAt(page: Pages.game) {
				GameView()
					.transition(.slideAndFadeIn)
					.environmentObject(grid)
					.environmentObject(settings)
					.environmentObject(PauseHolder())
					.environmentObject(TimerHolder())
			} else if viewRouter.currentlyAt(page: Pages.statistics) {
				StatisticsView()
					.transition(.slideAndFadeIn)
			} else if viewRouter.currentlyAt(page: Pages.strategies) {
				StrategiesView()
					.transition(.slideAndFadeIn)
			} else if viewRouter.currentlyAt(page: Pages.settings) {
				SettingsView()
					.transition(.slideAndFadeIn)
					.environmentObject(settings)
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
