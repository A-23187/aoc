// --- Day 16: Reindeer Maze ---
// https://adventofcode.com/2024/day/16

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day16.txt")
  content.split("\n").collect()
}

///|
let debug = false

///| part 1: trace_path = false, part 2: trace_path = true
fn solve_maze_in_best_way(
  maze : Array[String],
  trace_path~ : Bool = false
) -> (Int, Array[Array[(Int, Int)]]) {
  fn get_position(target : Char) -> (Int, Int) {
    for i, row in maze {
      for j, tile in row {
        if tile == target {
          return (i, j)
        }
      }
    }
    return (-1, -1)
  }

  // (si, sj): pos of start tile, (ei, ej): pos of end tile
  let (si, sj) = get_position('S')
  let (ei, ej) = get_position('E')
  // "^>v<"[k] means four facing directions and sk is the start facing
  let sk = 1
  let d = [-1, 0, 1, 0, -1]
  let int_max = (1 << 31) - 1
  // scores
  let scores = []
  for row in maze {
    let e = []
    for _ in row {
      e.push(Array::make(4, int_max))
    }
    scores.push(e)
  }
  // actions
  let actions = []
  if trace_path {
    for row in maze {
      let e = []
      for _ in row {
        e.push([[], [], [], []])
      }
      actions.push(e)
    }
  }
  // queue
  let q = @queue.of([(si, sj, sk, 0)])
  // bfs
  let mut lowest_score = int_max
  let ek = [] // the end facing directions of various best paths
  while not(q.is_empty()) {
    let (i, j, k, score) = q.pop().unwrap()
    if i == ei && j == ej {
      if score < lowest_score {
        lowest_score = score
        if trace_path {
          ek.clear()
        }
      }
      if trace_path && score == lowest_score {
        ek.push(k)
      }
      continue
    }
    // action = 0: clockwise, action = 1: counterclockwise
    for action, k_ in [(k + 1) % 4, (k + 3) % 4] {
      let score_ = score + 1000
      if score_ < scores[i][j][k_] {
        scores[i][j][k_] = score_
        if trace_path {
          actions[i][j][k_].clear()
        }
        q.push((i, j, k_, score_))
      }
      if trace_path && score_ == scores[i][j][k_] {
        actions[i][j][k_].push(action)
      }
    }
    let (i_, j_, score_) = (i + d[k], j + d[k + 1], score + 1)
    if maze[i_][j_] == '#' {
      continue
    }
    if score_ < scores[i_][j_][k] {
      scores[i_][j_][k] = score_
      if trace_path {
        actions[i_][j_][k].clear()
      }
      q.push((i_, j_, k, score_))
    }
    if trace_path && score_ == scores[i_][j_][k] {
      actions[i_][j_][k].push(2) // action = 2: move forward one tile
    }
  }
  if trace_path {
    let maze_ = [[]]
    let paths = []
    let rpath = []
    fn dfs(i : Int, j : Int, k : Int) -> Unit {
      rpath.push((i, j, "^>v<"[k]))
      if i == si && j == sj && k == sk {
        if debug {
          rpath.rev_each(fn(state) {
            let (i, j, ch) = state
            maze_[i][j] = ch
          })
        }
        paths.push(rpath.rev())
        rpath.clear()
        return
      }
      for action in actions[i][j][k] {
        match action {
          0 => dfs(i, j, (k + 3) % 4)
          1 => dfs(i, j, (k + 1) % 4)
          2 => dfs(i - d[k], j - d[k + 1], k)
          x => x |> ignore
        }
      }
    }

    for ek_ in ek {
      if debug {
        maze_.clear()
        for row in maze {
          maze_.push(row.to_array())
        }
      }
      dfs(ei, ej, ek_)
      if debug {
        println("ek = \{ek_}")
        for row in maze_ {
          println(String::from_array(row))
        }
      }
    }
    (
      lowest_score,
      paths.map(fn(path) { path.map(fn(state) { (state.0, state.1) }) }),
    )
  } else {
    (lowest_score, [])
  }
}

///| part 1
fn lowest_score_to_solve_maze(maze : Array[String]) -> Int {
  return solve_maze_in_best_way(maze).0
}

///| part 2
fn count_tile_of_any_best_path(maze : Array[String]) -> Int {
  let (_, paths) = solve_maze_in_best_way(maze, trace_path=true)
  let duplicated_pos = @hashset.new()
  for path in paths {
    for pos in path {
      duplicated_pos.add(pos)
    }
  }
  duplicated_pos.size()
}

test {
  let maze = input!()
  assert_eq!(lowest_score_to_solve_maze(maze), 102488)
  assert_eq!(count_tile_of_any_best_path(maze), 559)
}
