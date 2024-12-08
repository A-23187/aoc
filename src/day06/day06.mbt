// --- Day 6: Guard Gallivant ---
// https://adventofcode.com/2024/day/6

///|
fn input() -> Array[String]! {
  let content = @fs.read_file_to_string!(path="input/day06.txt")
  content.split("\n").collect()
}

///|
fn get_guard_starting_position(map : Array[String]) -> (Int, Int) {
  for i = 0; i < map.length(); i = i + 1 {
    for j = 0; j < map[i].length(); j = j + 1 {
      if map[i][j] == '^' {
        return (i, j)
      }
    }
  }
  return (-1, -1)
}

///| part 1: additional_obstacle = None, part 2: additional_obstacle = Some(i, j)
fn get_guard_visited_positions(
  map : Array[String],
  starting_position : (Int, Int),
  additional_obstacle? : (Int, Int)
) -> @hashset.T[(Int, Int)] {
  let (r, c) = starting_position
  let positions : @hashset.T[(Int, Int)] = @hashset.new()
  let positions_with_direction : @hashset.T[(Int, Int, Int)] = @hashset.new()
  let d = [-1, 0, 1, 0, -1]
  let stuck_in_loop = for i = r, j = c, k = 0; true; {
    if additional_obstacle != None &&
      positions_with_direction.contains((i, j, k)) {
      break true
    }
    if i >= 0 && i < map.length() && j >= 0 && j < map[i].length() {
      if map[i][j] != '#' && Some((i, j)) != additional_obstacle {
        positions.add((i, j))
        if additional_obstacle != None {
          positions_with_direction.add((i, j, k))
        }
        continue i + d[k], j + d[k + 1], k
      } else {
        let kk = (k + 1) % 4
        continue i - d[k] + d[kk], j - d[k + 1] + d[kk + 1], kk
      }
    } else {
      break false
    }
  } else { // unreachable
    false
  }
  if stuck_in_loop {
    @hashset.new()
  } else {
    positions
  }
}

///| part 1
fn count_guard_visited_positions(map : Array[String]) -> Int {
  get_guard_visited_positions(map, get_guard_starting_position(map)).size()
}

///| part 2
fn count_possible_obstacle_positions(map : Array[String]) -> Int {
  let mut cnt = 0
  let starting_position = get_guard_starting_position(map)
  for pos in get_guard_visited_positions(map, starting_position) {
    if get_guard_visited_positions(
        map,
        starting_position,
        additional_obstacle=pos,
      ).is_empty() {
      cnt = cnt + 1
    }
  }
  cnt
}

test {
  let map = input!()
  assert_eq!(count_guard_visited_positions(map), 5516)
  assert_eq!(count_possible_obstacle_positions(map), 2008)
}
