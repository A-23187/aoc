// --- Day 15: Warehouse Woes ---
// https://adventofcode.com/2024/day/15

///|
fn input() -> (Array[Array[Char]], String)! {
  let content = @fs.read_file_to_string!(path="input/day15.txt")
  let warehouse = []
  let movements = StringBuilder::new()
  let mut see_blank_line = false
  for line in content.split("\n") {
    if line.is_blank() {
      see_blank_line = true
      continue
    }
    if not(see_blank_line) {
      warehouse.push(line.iter().map(fn(ch) { ch }).collect())
    } else {
      movements.write_string(line)
    }
  }
  (warehouse, movements.to_string())
}

///| part 1
fn sum_of_gps_coordinate(
  warehouse : Array[Array[Char]],
  movements : String,
  twice_warehouse~ : Bool = false
) -> Int {
  if twice_warehouse {
    for i, row in warehouse {
      let n = row.length()
      row.reserve_capacity(2 * n)
      row.resize(2 * n, '.')
      for j = n - 1, k = 2 * n - 1; j >= 0; j = j - 1, k = k - 2 {
        let s = match row[j] {
          'O' => "[]"
          '@' => "@."
          c => "\{c}\{c}"
        }
        row[k - 1] = s[0]
        row[k] = s[1]
      }
      warehouse[i] = row
    }
  }
  let d = { '^': (-1, 0), 'v': (1, 0), '<': (0, -1), '>': (0, 1) }
  let pos = (fn() {
    for i, row in warehouse {
      for j, ch in row {
        if ch == '@' {
          return (i, j)
        }
      }
    }
    return (-1, -1)
  })()
  let mut i = pos.0
  let mut j = pos.1
  for mov in movements {
    let (di, dj) = match d[mov] {
      Some((di, dj)) => (di, dj)
      None => (0, 0)
    }
    let (ii, jj) = (i + di, j + dj)
    if warehouse[ii][jj] == '#' {
      continue
    }
    if warehouse[ii][jj] == 'O' {
      for i = ii, j = jj; warehouse[i][j] != '.'; {
        if warehouse[i][j] == '#' {
          break
        } else if warehouse[i][j] == 'O' {
          continue i + di, j + dj
        }
      } else {
        warehouse[ii][jj] = '.'
        warehouse[i][j] = 'O'
      }
    }
    if warehouse[ii][jj] == '.' {
      warehouse[i][j] = '.'
      warehouse[ii][jj] = '@'
      i = ii
      j = jj
    }
  }
  let mut sum = 0
  for i, row in warehouse {
    for j, ch in row {
      if ch == 'O' {
        sum = sum + 100 * i + j
      }
    }
  }
  sum
}

test {
  let (warehouse, movements) = input!()
  assert_eq!(sum_of_gps_coordinate(warehouse, movements), 1471826)
  println(sum_of_gps_coordinate(warehouse, movements, twice_warehouse=true))
}
