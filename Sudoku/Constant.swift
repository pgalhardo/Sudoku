//
//  Constant.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct Screen {
	static let lineThickness: CGFloat = 2
	static let size: CGRect = UIScreen.main.bounds
	static let width: CGFloat = UIScreen.main.bounds.width
	static let height: CGFloat = UIScreen.main.bounds.height
	static let cellWidth: CGFloat = UIScreen.main.bounds.size.width * 0.95 / 9
}

struct Pages {
	static let home: Int = 0
	static let game: Int = 1
	static let settings: Int = 2
	static let statistics: Int = 3
	static let strategies: Int = 3
}

struct Colors {
	static let ActiveBlue: Color = Color(red: 178 / 255,
								green: 210 / 255,
								blue: 256 / 255)
	static let LightBlue: Color = Color(red: 218 / 255,
								green: 225 / 255,
								blue: 231 / 255)
	static let MatteBlack: Color = Color(red: 27 / 255,
								green: 27 / 255,
								blue: 27 / 255)
	static let EraserPink: Color = Color(red: 180 / 255,
								green: 110 / 255,
								blue: 110 / 255)
	static let DeepBlue: Color = Color(red: 45 / 255,
								green: 75 / 255,
								blue: 142 / 255)
	static let MaastrichtBlue: Color = Color(red: 11 / 255,
								green: 19 / 255,
								blue: 43 / 255)
	static let YankeesBlue: Color = Color(red: 28 / 255,
								green: 37 / 255,
								blue: 65 / 255)
	static let PoliceBlue: Color = Color(red: 58 / 255,
								green: 80 / 255,
								blue: 107 / 255)
	static let SeaSerpent: Color = Color(red: 91 / 255,
								green: 192 / 255,
								blue: 190 / 255)
	static let Aquamarine: Color = Color(red: 111 / 255,
								green: 255 / 255,
								blue: 233 / 255)
}

struct Puzzles {
	static let simple: String = "720096003000205000080004020000000060106503807040000000030800090000702000200430018"
	static let hard: String = "000000000000003085001020000000507000004000100090000000500000073002010000000040009"
}
