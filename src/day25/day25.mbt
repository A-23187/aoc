// --- Day 25: Code Chronicle ---
// https://adventofcode.com/2024/day/25

///|
fn input() -> (Array[Array[String]], Array[Array[String]])! {
  let content = @fs.read_file_to_string!(path="input/day25.txt")
  let locks = []
  let keys = []
  for lines in content.split("\n\n") {
    (match lines[0] {
      '#' => locks
      '.' => keys
      _ => abort("Invalid input.")
    }).push(lines.split("\n").collect())
  }
  (locks, keys)
}

///|
fn number_of_valid_lock_key_pair(
  locks : Array[Array[String]],
  keys : Array[Array[String]]
) -> Int {
  fn get_heights(lock_or_key : Array[String]) -> Array[Int] {
    let heights = Array::make(lock_or_key[0].length(), 0)
    for i, c in lock_or_key[0] {
      for j, row in lock_or_key {
        if row[i] != c {
          heights[i] = j
          break
        }
      }
    }
    return heights
  }

  let all_key_heights = []
  for key in keys {
    all_key_heights.push(get_heights(key))
  }
  let mut cnt = 0
  for lock in locks {
    let lock_heights = get_heights(lock)
    for i, _ in keys {
      let key_heights = all_key_heights[i]
      for j, _ in lock_heights {
        if lock_heights[j] > key_heights[j] {
          break
        }
      } else {
        cnt = cnt + 1
      }
    }
  }
  cnt
}

test {
  let (locks, keys) = input!()
  assert_eq!(number_of_valid_lock_key_pair(locks, keys), 3090)
}
