// --- Day 8: Resonant Collinearity ---
// https://adventofcode.com/2024/day/8

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day08.txt")
  content.split("\n").collect()
}

///|
fn get_antennas(map : Array[String]) -> @hashmap.T[Char, Array[(Int, Int)]] {
  let antennas = @hashmap.new()
  for i = 0; i < map.length(); i = i + 1 {
    for j = 0; j < map[i].length(); j = j + 1 {
      if map[i][j] == '.' {
        continue
      }
      if not(antennas.contains(map[i][j])) {
        antennas[map[i][j]] = []
      }
      antennas[map[i][j]].unwrap().push((i, j))
    }
  }
  antennas
}

///| part 1
fn num_of_unique_antinode(map : Array[String]) -> Int {
  let antennas = get_antennas(map)
  let s : @hashset.T[(Int, Int)] = @hashset.new()
  for a in antennas {
    let (_, pos) = a
    for i = 0; i < pos.length() - 1; i = i + 1 {
      for j = i + 1; j < pos.length(); j = j + 1 {
        let (ri, ci) = pos[i]
        let (rj, cj) = pos[j]
        for rc in [(2 * ri - rj, 2 * ci - cj), (2 * rj - ri, 2 * cj - ci)] {
          let (r, c) = rc
          if r >= 0 && r < map.length() && c >= 0 && c < map[r].length() {
            s.add((r, c))
          }
        }
      }
    }
  }
  s.size()
}

///| part 2
fn num_of_unique_antinode2(map : Array[String]) -> Int {
  let antennas = get_antennas(map)
  let s : @hashset.T[(Int, Int, Char)] = @hashset.new()
  for a in antennas {
    let (_, pos) = a
    for i = 0; i < pos.length() - 1; i = i + 1 {
      for j = i + 1; j < pos.length(); j = j + 1 {
        let (ri, ci) = pos[i]
        let (rj, cj) = pos[j]
        let (rd, cd) = (rj - ri, cj - ci)
        for k = -1; true; k = k - 1 {
          let (r, c) = (ri + k * rd, ci + k * cd)
          if not(r >= 0 && r < map.length() && c >= 0 && c < map[r].length()) {
            break
          }
          s.add((r, c, map[r][c]))
        }
        for k = 0; true; k = k + 1 {
          let (r, c) = (ri + k * rd, ci + k * cd)
          if not(r >= 0 && r < map.length() && c >= 0 && c < map[r].length()) {
            break
          }
          s.add((r, c, map[r][c]))
        }
      }
    }
  }
  s.size()
}

test {
  let map = input!()
  assert_eq!(num_of_unique_antinode(map), 280)
  assert_eq!(num_of_unique_antinode2(map), 958)
}
