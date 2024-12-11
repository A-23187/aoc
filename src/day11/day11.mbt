// --- Day 11: Plutonian Pebbles ---
// https://adventofcode.com/2024/day/11

///|
fn input() -> Array[Int64]! {
  let content = @fs.read_file_to_string!(path="input/day11.txt")
  let nums = []
  for item in content.trim_end(" \t\r\n").split(" ") {
    nums.push(@strconv.parse_int64!(item))
  }
  nums
}

///| part 1: n = 25, part 2: n = 75
fn count_stones_after_blinking_n_times(stones : Array[Int64], n : Int) -> Int64 {
  fn len(stone : Int64) -> Int {
    for l = 0, s = stone; s > 0; {
      continue l + 1, s / 10
    } else {
      l
    }
  }

  let power = [1L, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000]
  let cache = @hashmap.new()
  fn dfs(stone : Int64, n : Int) -> Int64 {
    if cache.contains((stone, n)) {
      return cache[(stone, n)].unwrap()
    }
    let cnt = if n == 0 {
      1L
    } else if stone == 0 {
      dfs(stone + 1, n - 1)
    } else {
      let len = len(stone)
      if len % 2 == 0 {
        dfs(stone / power[len / 2], n - 1) + dfs(stone % power[len / 2], n - 1)
      } else {
        dfs(stone * 2024, n - 1)
      }
    }
    cache[(stone, n)] = cnt
    cnt
  }

  stones.fold(init=0L, fn(cnt, stone) -> Int64 { cnt + dfs(stone, n) })
}

test {
  let stones = input!()
  assert_eq!(count_stones_after_blinking_n_times(stones, 25), 212655)
  assert_eq!(count_stones_after_blinking_n_times(stones, 75), 253582809724830)
}
