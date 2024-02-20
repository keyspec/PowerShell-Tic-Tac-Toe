# Complete PowerShell Tic-Tac-Toe Game with Colored X and O

class GameBoard {
    [string[]]$board = @(' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ')

    GameBoard() {}

    [void]DisplayBoard() {
        Write-Host "Board Layout:    Current Board:"
        for ($i = 0; $i -lt $this.board.Length; $i += 3) {
            $this.PrintRow($i)
            if ($i -lt 6) {
                Write-Host "---+---+---     ---+---+---"
            }
        }
        Write-Host "Enter a position (0-8) based on the board layout."
    }

    [void]PrintRow($startIndex) {
        for ($j = 0; $j -lt 3; $j++) {
            $position = $startIndex + $j
            if ($this.board[$position] -eq 'X') {
                Write-Host -NoNewline " X" -ForegroundColor Blue
            } elseif ($this.board[$position] -eq 'O') {
                Write-Host -NoNewline " O" -ForegroundColor Red
            } else {
                Write-Host -NoNewline " $($this.board[$position])"
            }
            
            if ($j -lt 2) {
                Write-Host -NoNewline " |"
            }
        }

        if ($startIndex -eq 0) {
            Write-Host "       0 | 1 | 2" -NoNewline
        } elseif ($startIndex -eq 3) {
            Write-Host "       3 | 4 | 5" -NoNewline
        } else {
            Write-Host "       6 | 7 | 8" -NoNewline
        }

        Write-Host
    }

    [bool]MakeMove([int]$Position, [char]$Player) {
        if ($this.board[$Position] -eq ' ') {
            $this.board[$Position] = $Player
            return $true
        } else {
            Write-Host "This position is already taken."
            return $false
        }
    }

    [string]CheckGame() {
        $winConditions = @(
            (0,1,2), (3,4,5), (6,7,8), # rows
            (0,3,6), (1,4,7), (2,5,8), # columns
            (0,4,8), (2,4,6)           # diagonals
        )

        foreach ($condition in $winConditions) {
            if ($this.board[$condition[0]] -ne ' ' -and
                $this.board[$condition[0]] -eq $this.board[$condition[1]] -and
                $this.board[$condition[1]] -eq $this.board[$condition[2]]) {
                return $this.board[$condition[0]]
            }
        }

        if (' ' -notin $this.board) {
            return 'Tie'
        }

        return $null
    }
}

# Main game loop
$gameBoard = [GameBoard]::new()
$currentPlayer = 'X'

while ($true) {
    Clear-Host
    $gameBoard.DisplayBoard()
    $position = Read-Host "Player $currentPlayer, enter a position (0-8)"
    
    if (!($position -match '^\d$') -or $position -lt 0 -or $position -gt 8) {
        Write-Host "Invalid position. Please enter a number between 0 and 8."
        Start-Sleep -Seconds 2
        continue
    }
    
    if (!($gameBoard.MakeMove($position, $currentPlayer))) {
        Start-Sleep -Seconds 2
        continue
    }

    $result = $gameBoard.CheckGame()
    if ($result) {
        Clear-Host
        $gameBoard.DisplayBoard()
        if ($result -eq 'Tie') {
            Write-Host "The game is a tie!"
        } else {
            Write-Host "Player $result wins!"
        }
        break
    }

    $currentPlayer = if ($currentPlayer -eq 'X') { 'O' } else { 'X' }
}

Write-Host "Game over! Thanks for playing."
