//
//  Constant.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

let UNDEFINED: Int = 0

enum Screen {
	static let size: CGRect = UIScreen.main.bounds
	static let width: CGFloat = UIScreen.main.bounds.width
	static let height: CGFloat = UIScreen.main.bounds.height
	static let cellWidth: CGFloat = UIScreen.main.bounds.size.width * 0.95 / 9
	static let lineThickness: CGFloat = 2
}

enum Pages {
	static let home:       Int = 0
	static let game:       Int = 1
	static let settings:   Int = 2
	static let statistics: Int = 3
	static let strategies: Int = 4
}

enum InputType {
	static let system: Int = 0
	static let user:   Int = 1
	static let error:  Int = 2
}

enum Colors {
	static let DeepBlue:   Color = Color(red: 45 / 255,
										 green: 75 / 255,
										 blue: 142 / 255)
	static let ActiveBlue: Color = Color(UIColor(named: "ActiveBlue")!)
	static let LightBlue:  Color = Color(UIColor(named: "LightBlue")!)
	static let MatteBlack: Color = Color(red: 27 / 255,
										 green: 27 / 255,
										 blue: 27 / 255)
	static let Golden:     Color = Color(UIColor(named: "Golden")!)
}
