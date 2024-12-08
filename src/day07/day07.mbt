// --- Day 7: Bridge Repair ---
// https://adventofcode.com/2024/day/7

///|
fn input() -> Array[(Int64, Array[Int64])]! {
  let result = []
  let content = @fs.read_file_to_string!(path="input/day07.txt")
  for line in content.split("\n") {
    let mut target = 0L
    let nums = []
    for item in line.split(" ") {
      if item[item.length() - 1] == ':' {
        target = @strconv.parse_int64!(
          item.substring(start=0, end=item.length() - 1),
        )
      } else {
        nums.push(@strconv.parse_int64!(item))
      }
    }
    result.push((target, nums))
  }
  result
}

///|
fn total_calibration(
  equations : Array[(Int64, Array[Int64])],
  support_concat~ : Bool = false
) -> Int64 {
  let ops = [
    fn(a : Int64, b : Int64) { a + b },
    fn(a : Int64, b : Int64) { a * b },
  ]
  if support_concat {
    ops.push(
      fn(a : Int64, b : Int64) {
        let mut ans = a
        for v = b; v > 0; v = v / 10 {
          ans = ans * 10
        }
        ans = ans + b
        ans
      },
    )
  }
  fn check(equation : (Int64, Array[Int64])) -> Bool {
    let (target, nums) = equation
    fn dfs(i : Int, v : Int64) -> Bool {
      if i == nums.length() {
        v == target
      } else {
        for op in ops {
          if dfs(i + 1, op(v, nums[i])) {
            break true
          }
        } else {
          false
        }
      }
    }

    return dfs(1, nums[0])
  }

  equations.fold(
    init=0,
    fn(sum, equation) { if check(equation) { sum + equation.0 } else { sum } },
  )
}

test {
  let equations = input!()
  assert_eq!(total_calibration(equations), 3598800864292)
  assert_eq!(total_calibration(equations, support_concat=true), 340362529351427)
}
