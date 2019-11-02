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
}

struct Colors {
	static let ActiveBlue: Color = Color(red: 178 / 255,
								green: 210 / 255,
								blue: 256 / 255)
	static let LightBlue: Color = Color(red: 218 / 255,
								green: 225 / 255,
								blue: 231 / 255)
}
