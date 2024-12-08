// --- Day 6: Guard Gallivant ---
// https://adventofcode.com/2024/day/6

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day06.txt")
  content.split("\n").collect()
}

///|
fn count_visited_position(map : Array[String]) -> Int {
  let (r, c) = (fn() {
    for i = 0; i < map.length(); i = i + 1 {
      for j = 0; j < map[i].length(); j = j + 1 {
        if map[i][j] == '^' {
          return (i, j)
        }
      }
    }
    return (-1, -1)
  })()
  let s : @hashset.T[(Int, Int)] = @hashset.new()
  let d = [-1, 0, 1, 0, -1]
  for i = r, j = c, k = 0; true; {
    if i >= 0 && i < map.length() && j >= 0 && j < map[i].length() {
      if map[i][j] != '#' {
        s.add((i, j))
        continue i + d[k], j + d[k + 1], k
      } else {
        let kk = (k + 1) % 4
        continue i - d[k] + d[kk], j - d[k + 1] + d[kk + 1], kk
      }
    } else {
      break
    }
  }
  s.size()
}

///|
fn count_possible_obstacle_position(map : Array[String]) -> Int {
  map.length()
}

test {
  let map = input!()
  assert_eq!(count_visited_position(map), 5516)
  println(count_possible_obstacle_position(map))
}
