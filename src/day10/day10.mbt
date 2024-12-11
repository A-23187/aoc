// --- Day 10: Hoof It ---
// https://adventofcode.com/2024/day/10

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day10.txt")
  content.split("\n").collect()
}

///| part 1
/// part 1: check_visited = true, part 2: check_visite = false
fn total_trailhead_score(
  map : Array[String],
  check_visited~ : Bool = true
) -> Int {
  let d = [-1, 0, 1, 0, -1]
  fn bfs(i : Int, j : Int) -> Int {
    let mut cnt = 0
    let q = @queue.of([(i, j)])
    let visited = @hashset.of([(i, j)])
    while not(q.is_empty()) {
      let (i, j) = q.pop().unwrap()
      if map[i][j] == '9' {
        cnt = cnt + 1
      }
      for k = 0; k < 4; k = k + 1 {
        let ii = i + d[k]
        let jj = j + d[k + 1]
        if ii >= 0 &&
          ii < map.length() &&
          jj >= 0 &&
          jj < map[i].length() &&
          map[ii][jj] - map[i][j] == 1 &&
          (not(check_visited) || not(visited.contains((ii, jj)))) {
          visited.add((ii, jj))
          q.push((ii, jj))
        }
      }
    }
    cnt
  }

  let mut score = 0
  for i = 0; i < map.length(); i = i + 1 {
    for j = 0; j < map[i].length(); j = j + 1 {
      if map[i][j] == '0' {
        score = score + bfs(i, j)
      }
    }
  }
  score
}

///| part 2
fn total_trailhead_rating(map : Array[String]) -> Int {
  total_trailhead_score(map, check_visited=false)
}

test {
  let map = input!()
  assert_eq!(total_trailhead_score(map), 796)
  assert_eq!(total_trailhead_rating(map), 1942)
}
