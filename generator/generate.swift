let UNDEFINED: Int = 0
var grid: [[Int]] = Array(repeating: Array(repeating: UNDEFINED, count: 9),
                          count: 9)
var solution: [[Int]] = Array(repeating: Array(repeating: UNDEFINED, count: 9),
                              count: 9)
var tokenFrequency: [Int] = Array(repeating: 0,
                                  count: 9)
var solutions: Int = 0

let easy: String = "000105000140000670080002400063070010900000003010090520007200080026000035000409000"
let hard: String = "000000000000003085001020000000507000004000100090000000500000073002010000000040009"
let moderate: String = "720096003000205000080004020000000060106503807040000000030800090000702000200430018"

let puzzles: [String] = [easy, moderate, hard]

/*============================================================================
    Make up a Sudoku puzzle.
    ------------------------
    generate():
    fill()           -> fill the board with a valid sudoku puzzle.
    randomize()      -> assign each token to a random number.
    remove_numbers() -> removes clues to create a playable board.
 ==========================================================================*/

func generate() -> Void {
    fill()
    randomize()
    removeNumbers()
    //computeTokenFrequency()
}


@discardableResult func fill() -> Bool {
    var tokens: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    var row: Int = 0
    var col: Int = 0
    
    for i in (0 ..< 81) {
        row = i / 9
        col = i % 9
        
        if grid[row][col] == UNDEFINED {
            tokens = tokens.shuffled()
            
            for token in tokens {
                let token2Int: Int = Int(Unicode.Scalar(token)!.value)
                
                if possible(token: token2Int, row: row, col: col) {
                    grid[row][col] = token2Int
                    // self.inputType[row][col] = InputType.system
                    
                    if full() {
                        return true
                    }
                    else if fill() {
                        return true
                    }
                }
            }
            break
        }
    }
    grid[row][col] = UNDEFINED
    return false
}


func randomize() -> Void {
    var tokens: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    tokens = tokens.shuffled()
    
    for i in (0 ..< 81) {
        let row: Int = i / 9
        let col: Int = i % 9
        let int2Token: String = String(Character(UnicodeScalar(grid[row][col])!))
        grid[row][col] = tokens.firstIndex(of: int2Token)! + 1
    }
}


func removeNumbers() -> Void {
    var removed: Int = 0
    
    // Make a list of all 81 cell positions and shuffle it randomly.
    var pos: [Int] = Array(0 ..< 81)
    pos = pos.shuffled()
    
    // As long as the list is not empty,
    // take the next position from the list
    // and remove the number from the related cell.
    
    while pos.count > 0 {
        let nextpos: Int = pos.removeFirst()
        let row: Int = nextpos / 9
        let col: Int = nextpos % 9
        
        let prev: [[Int]] = grid
        
        grid[row][col] = UNDEFINED
        let solutions: Int = solve()
        
        grid = prev
        
        if (solutions != 1) { continue }
        
        // self.inputType[row][col] = InputType.user
        grid[row][col] = UNDEFINED
        removed += 1
    }
    
    print("Clues + Solved:", 81 - removed, "/ 81")
}


func computeTokenFrequency() -> Void {
    for row in grid {
        for val in row {
            if val != UNDEFINED {
                tokenFrequency[val - 1] += 1
            }
        }
    }
}

/*==============================================================================
    Solve a Sudoku puzzle.
 ==========================================================================*/

func solve() -> Int {
    solutions = 0
    
    basicTechniques()
    if full() {
        solutions = 1
    }
    else {
        backtrack(prev: -1, pos: nextEmptyPos(ref: -1))
    }
    
    return solutions
}


func basicTechniques() -> Void {
    func nakedSingles(possibles: [[[Int]]]) -> Int {
        var solved: Int = 0
        
        for row in (0 ..< 9) {
            for col in (0 ..< 9) {
                if possibles[row][col].count == 1 {
                    solved += 1
                    grid[row][col] = possibles[row][col][0]
                }
            }
        }
        return solved
    }
    
    func hiddenSingles(possibles: [[[Int]]]) -> Int {
        
        func uniqueRow(row: Int, value: Int, possibles: [[Int]]) -> Bool {
            var count: Int = 0
            var index: Int = 0
            
            for col in (0 ..< 9) {
                for inner in (0 ..< possibles[col].count) {
                    if possibles[col][inner] == value {
                        count += 1
                        index = col
                    }
                }
            }
            
            if count == 1 {
                grid[row][index] = value
            }
            return count == 1
        }
        
        func uniqueCol(col: Int, value: Int, possibles: [[Int]]) -> Bool {
            var count: Int = 0
            var index: Int = 0
            
            for row in (0 ..< 9) {
                for inner in (0 ..< possibles[row].count) {
                    if possibles[row][inner] == value {
                        count += 1
                        index = row
                    }
                }
            }
            
            if count == 1 {
                grid[index][col] = value
            }
            return count == 1
        }
        
        func uniqueSquare(row: Int, col: Int, value: Int, possibles: [[[Int]]]) -> Bool {
            var square: [[Int]] = [[Int]]()
            for i in (row ..< row + 3) {
                for j in (col ..< col + 3) {
                    square.append(possibles[i][j])
                }
            }
            
            var count: Int = 0
            var index: Int = 0
            for outter in (0 ..< 9) {
                for inner in (0 ..< square[outter].count) {
                    if square[outter][inner] == value {
                        count += 1
                        index = outter
                    }
                }
            }
            
            if count == 1 {
                let rowOffset: Int = index / 3
                let colOffset: Int = index % 3
                grid[row + rowOffset][col + colOffset] = value
            }
            return count == 1
        }
        
        var found: Int = 0
        
        // detect hidden singles in rows
        for row in (0 ..< 9) {
            for value in (1 ... 9) {
                if uniqueRow(row: row,
                             value: value,
                             possibles: possibles[row]
                ) {
                    found += 1
                }
            }
        }
        
        // detect hidden singles in columns
        for col in (0 ..< 9) {
            for value in (1 ... 9) {
                if uniqueCol(col: col,
                             value: value,
                             possibles: possibles.map { $0[col] }
                ) {
                    found += 1
                }
            }
        }
        
        // detect hidden singles in boxes
        let delim: [Int] = [0, 3, 6]
        for row in delim {
            for col in delim {
                for value in (1 ... 9) {
                    if uniqueSquare(row: row,
                                    col: col,
                                    value: value,
                                    possibles: possibles
                    ) {
                        found += 1
                    }
                }
            }
        }
        return found
    }
    
    while true {
        let possibles: [[[Int]]] = computeGridPossibles()
        
        if nakedSingles(possibles: possibles) > 0 { continue }
        else if hiddenSingles(possibles: possibles) > 0 { continue }
        
        solution = grid
        return
    }
}


@discardableResult func backtrack(prev: Int, pos: Int) -> Bool {
    let row: Int = pos / 9
    let col: Int = pos % 9
    
    var possibles: [Int] = getPossibles(row: row, col: col)
    
    while possibles.count > 0 {
        let first: Int = possibles.removeFirst()
        grid[row][col] = first
        
        let nextpos: Int = nextEmptyPos(ref: pos)
        if nextpos == -1 {
            
            // Solution found. We must check if it is the only one (so far).
            solutions += 1
            if solutions > 1 {
                solution = Array(repeating: Array(repeating: UNDEFINED, count: 9), count: 9)
                return false
            }
            else {
                solution = grid
            }
        }
        else {
            backtrack(prev: pos, pos: nextpos)
            if solutions > 1 {
                return false
            }
        }
        
        // If we got here, everything after us failed.
        // We need to try another possible number.
    }
    
    grid[row][col] = UNDEFINED
    return false
}


func nextEmptyPos(ref: Int) -> Int {
    var nextpos: Int = ref + 1
    
    while true {
        let nextrow: Int = nextpos / 9
        let nextcol: Int = nextpos % 9
        if nextpos > 80 {
            // Board is filled
            return -1
        }
        else if grid[nextrow][nextcol] == UNDEFINED {
            return nextpos
        }
        nextpos += 1
    }
}


func getPossibles(row: Int, col: Int) -> [Int] {
    var possibles: [Int] = []
    
    for i in (1 ... 9) {
        if possible(token: i, row: row, col: col) {
            possibles.append(i)
        }
    }
    return possibles
}


func computeGridPossibles() -> [[[Int]]] {
    var possibles: [[[Int]]] = Array(repeating: Array(repeating: [],
                                                      count: 9),
                                     count: 9)
    
    for row in (0 ..< 9) {
        for col in (0 ..< 9) {
            if grid[row][col] == UNDEFINED {
                possibles[row][col] = getPossibles(row: row, col: col)
            }
        }
    }
    return possibles
}

/*==============================================================================
 Grid utils.
 ==========================================================================*/

func print_grid(grid: [[Int]]) -> Void {
    print(String(repeating: "-", count: 37))
    
    for (i, row) in grid.enumerated() {
        var line: String = ""
        var count: Int = 0
        
        for x in row {
            count += 1
            
            if count % 3 == 0 {
                if x != UNDEFINED {
                    line.append(" " + String(x) + " |")
                } else {
                    line.append("   |")
                }
            }
            else {
                if x != UNDEFINED {
                    line.append(" " + String(x) + "  ")
                } else {
                    line.append("    ")
                }
            }
        }
        print("|" + line)
        
        if i == 8 {
            print(String(repeating: "-", count: 37))
        }
        else if i % 3 == 2 {
            print("|" + String(repeating: "---+", count: 8) + "---|")
        }
        else {
            print("|" + String(repeating: "   +", count: 8) + "   |")
        }
    }
}


func possible(token: Int, row: Int, col: Int) -> Bool {
    return !tokenInRow(token: token, row: row)
    && !tokenInCol(token: token, col: col)
    && !tokenInSquare(token: token, row: row, col: col)
}


func full() -> Bool {
    for row in (0 ..< 9) {
        for col in (0 ..< 9) {
            if grid[row][col] == UNDEFINED {
                return false
            }
        }
    }
    return true
}


func getSquare(row: Int, col: Int) -> [[Int]] {
    // this points to upper left corner
    let row: Int = (row / 3) * 3
    let col: Int = (col / 3) * 3
    var square: [[Int]] = [[Int]]()
    
    for i in (row ..< row + 3) {
        square.append([grid[i][col],
                       grid[i][col + 1],
                       grid[i][col + 2]])
    }
    return square
}


func tokenInRow(token: Int, row: Int) -> Bool {
    return grid[row].filter { $0 == token }.count > 0
}


func tokenInCol(token: Int, col: Int) -> Bool {
    return grid.filter { $0[col] == token }.count > 0
}


func tokenInSquare(token: Int, row: Int, col: Int) -> Bool {
    let square: [[Int]] = getSquare(row: row, col: col)
    
    return square[0].contains(token)
    || square[1].contains(token)
    || square[2].contains(token)
}

/*==============================================================================
 ImpExp utils.
 ==========================================================================*/

func load(puzzle: String) -> Void {
    var str: String = puzzle
    var count: Int = 0
    //var user: Bool = false
    
    while !str.isEmpty {
        let row: Int = count / 9
        let col: Int = count % 9
        let char: Character = str.removeFirst()
        
        if "0" <= char && char <= "9" {
            let value: Int = Int(String(char)) ?? 0
            
            grid[row][col] = value
            
            /*
             user == true
             ? (self.inputType[row][col] = InputType.user)
             : (self.inputType[row][col] = InputType.system)
             */
            
            //user = false
            
            count += 1
            if (value > 0) {
                tokenFrequency[value - 1] += 1
            }
        }
        /*
         else if char == "u" {
         user = true
         }
         */
    }
}


func store() -> String {
    var str: String = String()
    
    for row in (0 ..< 9) {
        for col in (0 ..< 9) {
            /*
             if (self.inputType[row][col] == InputType.user) {
             str.append("u")
             }
             */
            str.append(String(grid[row][col]))
        }
    }
    return str
}

/*==============================================================================
 Tests.
 ==========================================================================*/

func solve_test() {
    print("\n#####################################\n")
    print("             Solve Test                \n")
    
    var score: Int = 0
    for puzzle in puzzles {
        
        load(puzzle: puzzle)
        score += solve()
        print_grid(grid: solution)
        
        print("\n#####################################\n")
    }
    
    print("Score:", score, "/", puzzles.count)
}


func generate_test() {
    print("\n#####################################\n")
    print("            Generate Test              \n")
    
    generate()
    print_grid(grid: grid)
    
    print("\nExported board:\n" + store())
}

generate_test()
//solve_test()
