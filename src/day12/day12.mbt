// --- Day 12: Garden Groups ---
// https://adventofcode.com/2024/day/12

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day12.txt")
  content.split("\n").collect()
}

///| part 1
fn total_fencing_price_1(map : Array[String]) -> Int {
  let mut price = 0
  let mut area = 0
  let mut perimeter = 0
  let visited = []
  for row in map {
    visited.push(Array::make(row.length(), false))
  }
  fn dfs(i : Int, j : Int) -> Unit {
    for d = [-1, 0, 1, 0, -1], k = 0; k < 4; k = k + 1 {
      let ii = i + d[k]
      let jj = j + d[k + 1]
      if ii >= 0 &&
        ii < map.length() &&
        jj >= 0 &&
        jj < map[i].length() &&
        map[ii][jj] == map[i][j] {
        if not(visited[ii][jj]) {
          area = area + 1
          visited[ii][jj] = true
          dfs(ii, jj)
        }
      } else {
        perimeter = perimeter + 1
      }
    }
  }

  for i = 0; i < map.length(); i = i + 1 {
    for j = 0; j < map[i].length(); j = j + 1 {
      if visited[i][j] {
        continue
      }
      area = 1
      perimeter = 0
      visited[i][j] = true
      dfs(i, j)
      price = price + area * perimeter
    }
  }
  price
}

///|
fn find(parent : Array[Int], i : Int) -> Int {
  if parent[i] == i {
    i
  } else {
    parent[i] = find(parent, parent[i])
    parent[i]
  }
}

///|
fn union(parent : Array[Int], i : Int, j : Int) -> Bool {
  if i < 0 ||
    i >= parent.length() ||
    parent[i] == -1 ||
    j < 0 ||
    j >= parent.length() ||
    parent[j] == -1 {
    return false
  }
  let ii = find(parent, i)
  let jj = find(parent, j)
  if ii == jj {
    false
  } else {
    parent[ii] = jj
    true
  }
}

///| part 2
fn total_fencing_price_2(map : Array[String]) -> Int {
  let mut price = 0
  let mut area = 0
  // disjoint-set
  let parents = []
  for k = 0; k < 4; k = k + 1 {
    let p = []
    let (m, n) = if k % 2 == 0 {
      (map.length(), map[0].length())
    } else {
      (map[0].length(), map.length())
    }
    for i = 0; i < m; i = i + 1 {
      p.push(Array::make(n, -1))
    }
    parents.push(p)
  }
  let mut side = 0
  // visited
  let visited = []
  for row in map {
    visited.push(Array::make(row.length(), false))
  }
  // dfs
  fn dfs(i : Int, j : Int) -> Unit {
    for d = [-1, 0, 1, 0, -1], k = 0; k < 4; k = k + 1 {
      let ii = i + d[k]
      let jj = j + d[k + 1]
      if ii >= 0 &&
        ii < map.length() &&
        jj >= 0 &&
        jj < map[i].length() &&
        map[ii][jj] == map[i][j] {
        if not(visited[ii][jj]) {
          area = area + 1
          visited[ii][jj] = true
          dfs(ii, jj)
        }
      } else {
        let (idx, parent) = if k % 2 == 0 {
          (j, parents[k][i])
        } else {
          (i, parents[k][j])
        }
        parent[idx] = idx
        side = side + 1
        if union(parent, idx, idx - 1) {
          side = side - 1
        }
        if union(parent, idx, idx + 1) {
          side = side - 1
        }
      }
    }
  }

  for i = 0; i < map.length(); i = i + 1 {
    for j = 0; j < map[i].length(); j = j + 1 {
      if visited[i][j] {
        continue
      }
      area = 1
      for p in parents {
        for row in p {
          for k = 0; k < row.length(); k = k + 1 {
            row[k] = -1
          }
        }
      }
      side = 0
      visited[i][j] = true
      dfs(i, j)
      price = price + area * side
    }
  }
  price
}

test {
  let map = input!()
  assert_eq!(total_fencing_price_1(map), 1546338)
  assert_eq!(total_fencing_price_2(map), 978590)
}
