//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct GridView: View {
	@Binding var isPaused: Bool

	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var viewRouter: ViewRouter

	private let frameSize: CGFloat = Screen.cellWidth * 9
	
	var body: some View {
		ZStack {
			Group {
				structure
				overlayLines
			}
				.disabled(isPaused || grid.full())
				.opacity(isPaused || grid.full() ? 0 : 1)
		}
			.frame(width: self.frameSize,
				   height: self.frameSize,
				   alignment: .center)
	}
	
	private var structure: some View {
		VStack(spacing: -1) {
			ForEach(0 ..< 9) { row in
				HStack(spacing: -1) {
					ForEach(0 ..< 9) { col in
						self.grid.render(
							row: row,
							col: col,
							fontSize: self.fontSize()
						)
						.frame(
							width: Screen.cellWidth,
							height: Screen.cellWidth
						)
						.border(Color.black, width: 1)
						.padding(.all, 0)
						.background(
							self.grid.colorAt(
								row: row,
								col: col
							)
						)
						.onTapGesture {
							self.grid.objectWillChange.send()
							self.grid.setActive(
								row: row,
								col: col,
								areas: self.settings.highlightAreas,
								similar: self.settings.highlightSimilar
							)
						}
					}
				}
			}
		}
	}
	
	private var overlayLines: some View {
		GeometryReader { geometry in
			Path { path in
				let factor: CGFloat = Screen.cellWidth * 3
				let lines: [CGFloat] = [1, 2]
				
				for i: CGFloat in lines {
					let vpos: CGFloat = i * factor
					path.move(to: CGPoint(x: vpos, y: 4))
					path.addLine(to: CGPoint(x: vpos, y: geometry.size.height - 4))
				}

				for i: CGFloat in lines {
					let hpos: CGFloat = i * factor
					path.move(to: CGPoint(x: 4, y: hpos))
					path.addLine(to: CGPoint(x: geometry.size.width - 4, y: hpos))
				}
			}
				.stroke(lineWidth: Screen.lineThickness)
		}
	}
	
	func fontSize() -> CGFloat {
		let size: Float = self.settings.fontSize
		return CGFloat(size as Float)
	}
}
