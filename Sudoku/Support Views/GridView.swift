//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct GridView: View {
	@Binding var _isPaused: Bool

	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
	@EnvironmentObject var _viewRouter: ViewRouter
	
	var body: some View {
		ZStack {
			Group {
				_structure
				_overlayLines
			}
				.opacity(_isPaused || exit() ? 0 : 1)
				.disabled(_isPaused || exit())
			
			VStack {
				Text("Em pausa")
					.font(.custom("CaviarDreams-Bold", size: 50))
				Text(String(format: "%02d%% completo", _grid.completion()))
					.font(.custom("CaviarDreams-Bold", size: 20))
			}
				.foregroundColor(.black)
				.shadow(radius: 10)
				.opacity(_isPaused ? 1 : 0)
				.animation(.spring())
			
			VStack {
				Text("Parabéns!")
					.font(.custom("CaviarDreams-Bold", size: 50))
				Text(String(format: "Terminado com %d erros", _grid.getErrorCount()))
					.font(.custom("CaviarDreams-Bold", size: 20))
				
				Button(
					action: {
						withAnimation(.easeIn) {
							UserDefaults.standard.set(nil,
													  forKey: "savedBoard")
							self._viewRouter.setCurrentPage(page: Pages.home)
						}
					},
					label: {
						Text("Sair")
							.font(.custom("CaviarDreams-Bold", size: 20))
					}
				)
					.frame(width: Screen.width * 0.55,
						   height: 50)
					.background(Colors.MatteBlack)
					.cornerRadius(40)
					.padding(.all, 7)
					.foregroundColor(.white)
					.shadow(radius: 20)
					.padding(.top, 20)
			}
				.foregroundColor(.black)
				.shadow(radius: 10)
				.opacity(exit() ? 1 : 0)
				.animation(.spring())
		}
			.frame(width: Screen.cellWidth * 9,
				   height: Screen.cellWidth * 9,
				   alignment: .center)
	}
	
	private var _structure: some View {
		VStack(spacing: -1) {
			ForEach(0 ..< 9) { row in
				HStack(spacing: -1) {
					ForEach(0 ..< 9) { col in
						self._grid.cellAt(
							row: row,
							col: col
						).render(fontSize: self._settings._fontSize)
							
							.frame(
								width: Screen.cellWidth,
								height: Screen.cellWidth
							)
							.border(Color.black, width: 1)
							.padding(.all, 0)
							.background(
								self._grid.cellAt(
									row: row,
									col: col
								).getColor()
							)
							
							.onTapGesture {
								self._grid.objectWillChange.send()
								self._grid.setActive(
									row: row,
									col: col,
									areas: self._settings._highlightAreas,
									similar: self._settings._highlightSimilar
								)
							}
					}
				}
			}
		}
	}
	
	private var _overlayLines: some View {
		GeometryReader { geometry in
			Path { path in
				let hlines = 2
				let vlines = 2
				for index in 1 ... vlines {
					let vpos: CGFloat = CGFloat(index) * Screen.cellWidth * 3
					path.move(to: CGPoint(x: vpos, y: 4))
					path.addLine(to: CGPoint(x: vpos, y: geometry.size.height - 4))
				}
				for index in 1 ... hlines {
					let hpos: CGFloat = CGFloat(index) * Screen.cellWidth * 3
					path.move(to: CGPoint(x: 4, y: hpos))
					path.addLine(to: CGPoint(x: geometry.size.width - 4, y: hpos))
				}
			}
				.stroke(lineWidth: Screen.lineThickness)
		}
	}
	
	func exit() -> Bool {
		return _grid.completion() == 100
	}
}
