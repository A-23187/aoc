// --- Day 20: Race Condition ---
// https://adventofcode.com/2024/day/20

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day20.txt")
  content.split("\n").collect()
}

///|
/// m: the max picoseconds of a single cheat
/// n: the min picoseconds to save
/// part 1: m = 2, part 2: m = 20
fn number_of_cheats_saving_n_picoseconds(
  map : Array[String],
  m~ : Int = 2,
  n~ : Int = 100
) -> Int {
  fn get_position(target : Char) -> (Int, Int) {
    for i, row in map {
      for j, c in row {
        if c == target {
          return (i, j)
        }
      }
    }
    (-1, -1)
  }

  // if the position (i, j) is in bound and no wall
  fn no_wall(i : Int, j : Int) -> Bool {
    i >= 0 &&
    i < map.length() &&
    j >= 0 &&
    j < map[i].length() &&
    map[i][j] != '#'
  }

  let (si, sj) = get_position('S')
  let (ei, ej) = get_position('E')
  let d = [-1, 0, 1, 0, -1]
  // collect all valid cheats
  let cheats = []
  // visited[i][j] means the steps need to visit (i, j)
  let visited = []
  for row in map {
    visited.push(Array::make(row.length(), 0))
  }
  visited[si][sj] = 1
  let q = @queue.of([(si, sj)])
  while not(q.is_empty()) {
    let (i, j) = q.pop().unwrap()
    for di = -m; di <= m; di = di + 1 {
      let max_dj = m - di.abs()
      for dj = -max_dj; dj <= max_dj; dj = dj + 1 {
        let (ii, jj) = (i + di, j + dj)
        if no_wall(ii, jj) && visited[ii][jj] != 0 {
          // push a new cheat starting from (ii, jj) and ending at (i, j)
          cheats.push((ii, jj, i, j))
        }
      }
    }
    if i == ei && j == ej {
      break
    }
    for k = 0; k < 4; k = k + 1 {
      let (ii, jj) = (i + d[k], j + d[k + 1])
      if no_wall(ii, jj) && visited[ii][jj] == 0 {
        visited[ii][jj] = visited[i][j] + 1
        q.push((ii, jj))
      }
    }
  }
  cheats.fold(init=0, fn(cnt, cheat) {
    let (i, j, ii, jj) = cheat
    // visited[ii][jj] - visited[i][j]: the steps need with out cheat
    // (abs(ii - i) + abs(jj - j)): the steps of cheat
    if visited[ii][jj] - visited[i][j] - ((ii - i).abs() + (jj - j).abs()) >= n {
      cnt + 1
    } else {
      cnt
    }
  })
}

test {
  let map = input!()
  assert_eq!(number_of_cheats_saving_n_picoseconds(map), 1415)
  assert_eq!(number_of_cheats_saving_n_picoseconds(map, m=20), 1022577)
}
