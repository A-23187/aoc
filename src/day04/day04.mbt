// --- Day 4: Ceres Search ---
// https://adventofcode.com/2024/day/4

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day04.txt")
  content.split("\n").collect()
}

///| part 1
fn xmas_count(board : Array[String]) -> Int {
  let mut cnt = 0
  for i = 0; i < board.length(); i = i + 1 {
    for j = 0; j < board[i].length(); j = j + 1 {
      if board[i][j] != 'X' {
        continue
      }
      for d = [-1, 0, 1, 0, -1, -1, 1, 1, -1], k = 0; k < 8; k = k + 1 {
        let mut ii = i
        let mut jj = j
        for ch in "MAS" {
          ii = ii + d[k]
          jj = jj + d[k + 1]
          if not(
              ii >= 0 &&
              ii < board.length() &&
              jj >= 0 &&
              jj < board[ii].length() &&
              board[ii][jj] == ch,
            ) {
            break
          }
        } else {
          cnt = cnt + 1
        }
      }
    }
  }
  cnt
}

///| part 2
fn x_mas_count(board : Array[String]) -> Int {
  let mut cnt = 0
  for i = 1; i < board.length() - 1; i = i + 1 {
    for j = 1; j < board[i].length() - 1; j = j + 1 {
      if board[i][j] != 'A' {
        continue
      }
      if (match
          (
            board[i - 1][j - 1],
            board[i - 1][j + 1],
            board[i + 1][j + 1],
            board[i + 1][j - 1],
          ) {
          ('M', 'M', 'S', 'S')
          | ('M', 'S', 'S', 'M')
          | ('S', 'S', 'M', 'M')
          | ('S', 'M', 'M', 'S') => true
          _ => false
        }) {
        cnt = cnt + 1
      }
    }
  }
  cnt
}

test {
  let board = input!()
  assert_eq!(xmas_count(board), 2551)
  println(x_mas_count(board))
}
