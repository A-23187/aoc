// --- Day 14: Restroom Redoubt ---
// https://adventofcode.com/2024/day/14

///|
fn input() -> Array[((Int, Int), (Int, Int))]! {
  let content = @fs.read_file_to_string!(path="input/day14.txt")
  let robots = []
  for line in content.split("\n") {
    let mut i = line.index_of("=") + 1
    let mut j = line.index_of(",", from=i)
    let mut k = line.index_of(" ", from=j + 1)
    let mut x = @strconv.parse_int!(line.substring(start=i, end=j))
    let mut y = @strconv.parse_int!(line.substring(start=j + 1, end=k))
    let p = (x, y)
    i = line.index_of("=", from=k) + 1
    j = line.index_of(",", from=i)
    k = line.length()
    x = @strconv.parse_int!(line.substring(start=i, end=j))
    y = @strconv.parse_int!(line.substring(start=j + 1, end=k))
    let v = (x, y)
    robots.push((p, v))
  }
  robots
}

///| part 1
fn total_safety_factor(
  robots : Array[((Int, Int), (Int, Int))],
  wide : Int,
  tall : Int,
  seconds : Int
) -> Int {
  let cnts = [[0, 0], [0, 0]]
  for robot in robots {
    let ((x, y), (dx, dy)) = robot
    let xx = (x + seconds * (dx + wide) % wide) % wide
    let yy = (y + seconds * (dy + tall) % tall) % tall
    if xx != wide / 2 && yy != tall / 2 {
      let i = xx / (wide / 2 + 1)
      let j = yy / (tall / 2 + 1)
      cnts[i][j] = cnts[i][j] + 1
    }
  }
  cnts[0][0] * cnts[0][1] * cnts[1][0] * cnts[1][1]
}

///| part 2
fn fewest_second_to_show_christmas_tree(
  robots : Array[((Int, Int), (Int, Int))],
  wide : Int,
  tall : Int
) -> Int {
  for n = 1; true; n = n + 1 {
    let m = []
    for i = 0; i < tall; i = i + 1 {
      m.push(Array::make(wide, ' '))
    }
    for i = 0; i < robots.length(); i = i + 1 {
      let ((x, y), (dx, dy)) = robots[i]
      let (xx, yy) = ((x + dx + wide) % wide, (y + dy + tall) % tall)
      robots[i] = ((xx, yy), (dx, dy))
      m[yy][xx] = '#'
    }
    let ok = for row in m {
      if String::from_array(row).index_of("##########") != -1 {
        break true
      }
    } else {
      false
    }
    if ok {
      for row in m {
        println(String::from_array(row))
      }
      break n
    }
  } else {
    -1
  }
}

test {
  let robots = input!()
  let (wide, tall, seconds) = (101, 103, 100)
  assert_eq!(total_safety_factor(robots, wide, tall, seconds), 233709840)
  assert_eq!(fewest_second_to_show_christmas_tree(robots, wide, tall), 6620)
}
