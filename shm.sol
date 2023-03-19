// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Sudoku {
    uint8 constant N = 9;
    uint8 constant EMPTY = 0;

    function checkWin(uint8[N][N] memory board) public pure returns (bool) {
        // Check rows
        for (uint8 i = 0; i < N; i++) {
            bool[N] memory found_values;
            for (uint8 j = 0; j < N; j++) {
                uint8 num = board[i][j];
                if (num == EMPTY) {
                    return false;
                }
                if (found_values[num - 1]) {
                    return false;
                }
                found_values[num - 1] = true;
            }
        }

        // Check columns
        for (uint8 j = 0; j < N; j++) {
            bool[N] memory found_values;
            for (uint8 i = 0; i < N; i++) {
                uint8 num = board[i][j];
                if (num == EMPTY) {
                    return false;
                }
                if (found_values[num - 1]) {
                    return false;
                }
                found_values[num - 1] = true;
            }
        }

        // Check regions
        for (uint8 r = 0; r < N; r += 3) {
            for (uint8 c = 0; c < N; c += 3) {
                bool[N] memory found_values;
                for (uint8 i = r; i < r + 3; i++) {
                    for (uint8 j = c; j < c + 3; j++) {
                        uint8 num = board[i][j];
                        if (num == EMPTY) {
                            return false;
                        }
                        if (found_values[num - 1]) {
                            return false;
                        }
                        found_values[num - 1] = true;
                    }
                }
            }
        }

        return true;
    }

    function computeBruteforce(uint8[N][N] memory board) public pure returns (uint8[N][N] memory) {
    uint8[N][N] memory solution;
    if (solveBoard(board, 0, 0, solution)) {
        return solution;
    } else {
        revert("No solution found");
    }
}


    function solveBoard(uint8[N][N] memory board, uint8 row, uint8 col, uint8[N][N] memory solution) public pure returns (bool) {
  // Base case: we have filled in all cells
  if (row == N) {
    // We found a solution, so return true and save it
    for (uint8 i = 0; i < N; i++) {
      for (uint8 j = 0; j < N; j++) {
        solution[i][j] = board[i][j];
      }
    }
    return true;
  }

  // If the current cell is not empty, move on to the next cell
  if (board[row][col] != EMPTY) {
    if (col == N - 1) {
      return solveBoard(board, row + 1, 0, solution);
    } else {
      return solveBoard(board, row, col + 1, solution);
    }
  }

  // Try all numbers from 1 to 9
  for (uint8 num = 1; num <= N; num++) {
    if (isValidMove(board, row, col, num)) {
      board[row][col] = num;
      if (col == N - 1) {
        if (solveBoard(board, row + 1, 0, solution)) {
          return true;
        }
      } else {
        if (solveBoard(board, row, col + 1, solution)) {
          return true;
        }
      }
      board[row][col] = EMPTY;
    }
  }

  // We have tried all numbers and none of them work, so backtrack
  return false;
}
   function isValidMove(uint8[N][N] memory board, uint8 row, uint8 col, uint8 num) public pure returns (bool) {
    // Check row
    for (uint8 j = 0; j < N; j++) {
        if (board[row][j] == num) {
            return false;
        }
    }
    
    // Check column
    for (uint8 i = 0; i < N; i++) {
        if (board[i][col] == num) {
            return false;
        }
    }
    
    // Check region
    uint8 r = row - row % 3;
    uint8 c = col - col % 3;
    for (uint8 i = r; i < r + 3; i++) {
        for (uint8 j = c; j < c + 3; j++) {
            if (board[i][j] == num) {
                return false;
            }
        }
    }
    
    return true;
}



}