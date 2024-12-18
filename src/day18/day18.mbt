// --- Day 18: RAM Run ---
// https://adventofcode.com/2024/day/18

///|
fn input() -> Array[(Int, Int)]! {
  let content = @fs.read_file_to_string!(path="input/day18.txt")
  let pos = []
  for line in content.split("\n") {
    let i = line.index_of(",")
    let x = @strconv.parse_int!(line.substring(start=0, end=i))
    let y = @strconv.parse_int!(line.substring(start=i + 1))
    pos.push((x, y))
  }
  pos
}

///|
fn bfs(mem : Array[Array[Char]], start : (Int, Int), end : (Int, Int)) -> Int {
  let d = [-1, 0, 1, 0, -1]
  let visited = @hashset.of([start])
  let q = @queue.of([start])
  let mut ans = 0
  while not(q.is_empty()) {
    for m = q.length(), i = 0; i < m; i = i + 1 {
      let (x, y) = q.pop().unwrap()
      if (x, y) == end {
        return ans
      }
      for k = 0; k < 4; k = k + 1 {
        let (xx, yy) = (x + d[k], y + d[k + 1])
        if yy >= 0 &&
          yy < mem.length() &&
          xx >= 0 &&
          xx < mem[yy].length() &&
          mem[yy][xx] != '#' &&
          not(visited.contains((xx, yy))) {
          visited.add((xx, yy))
          q.push((xx, yy))
        }
      }
    }
    ans = ans + 1
  }
  -1
}

///| part 1
fn minimum_step_to_reach_end(n : Int, m : Int, pos : Array[(Int, Int)]) -> Int {
  let mem = []
  for i = 0; i < n; i = i + 1 {
    mem.push(Array::make(n, ' '))
  }
  for i = 0; i < (if m < pos.length() { m } else { pos.length() }); i = i + 1 {
    let (x, y) = pos[i]
    mem[y][x] = '#'
  }
  let start = (0, 0)
  let end = (n - 1, n - 1)
  bfs(mem, start, end)
}

///| part 2
fn position_of_first_blocker(n : Int, pos : Array[(Int, Int)]) -> String {
  let mem = []
  for i = 0; i < n; i = i + 1 {
    mem.push(Array::make(n, ' '))
  }
  let start = (0, 0)
  let end = (n - 1, n - 1)
  for i, _ in pos {
    let (x, y) = pos[i]
    mem[y][x] = '#'
    if bfs(mem, start, end) == -1 {
      break "\{x},\{y}"
    }
  } else {
    ""
  }
}

test {
  let pos = input!()
  // wide and height of the memory space
  let n = 71
  // only pick the first 1024 byte positions
  let m = 1024
  assert_eq!(minimum_step_to_reach_end(n, m, pos), 354)
  assert_eq!(position_of_first_blocker(n, pos), "36,17")
}
