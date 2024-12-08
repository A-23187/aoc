// --- Day 3: Mull It Over ---
// https://adventofcode.com/2024/day/3

///|
fn input() -> String! {
  @fs.read_file_to_string!(path="input/day03.txt")
}

///| part 1
fn sum_of_valid_mul(str : String) -> Int {
  let mut sum = 0
  let mut i = 0
  for {
    // mul(a,b)
    // mul(
    i = str.index_of("mul(", from=i)
    if i == -1 {
      break
    }
    i = i + 4
    // a
    let mut j = str.index_of(",", from=i)
    if j == -1 {
      break
    }
    if j - i < 1 || j - i > 3 {
      continue
    }
    let mut r = @strconv.parse_int?(str.substring(start=i, end=j))
    i = j + 1
    if r.is_err() {
      continue
    }
    let a = r.unwrap()
    // b
    j = str.index_of(")", from=i)
    if j == -1 {
      break
    }
    if j - i < 1 || j - i > 3 {
      continue
    }
    r = @strconv.parse_int?(str.substring(start=i, end=j))
    i = j + 1
    if r.is_err() {
      continue
    }
    let b = r.unwrap()
    sum = sum + a * b
  }
  sum
}

test {
  let str = input!()
  assert_eq!(sum_of_valid_mul(str), 192767529)
}
