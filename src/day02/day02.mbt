// --- Day 2: Red-Nosed Reports ---
// https://adventofcode.com/2024/day/2

///|
fn input() -> Array[Array[Int]]! {
  let result = []
  let content = @fs.read_file_to_string!(path="input/day02.txt")
  for line in content.split("\n") {
    let nums = []
    for item in line.split(" ") {
      if not(item.is_empty()) {
        let num = @strconv.parse_int!(item)
        nums.push(num)
      }
    }
    result.push(nums)
  }
  result
}

///|
fn safe_report_count(reports : Array[Array[Int]]) -> Int {
  reports.fold(
    init=0,
    fn(cnt, report) {
      if report.length() < 2 {
        cnt + 1
      } else {
        for inc = report[0] < report[1], i = 1; i < report.length(); i = i + 1 {
          if report[i - 1] == report[i] || report[i - 1] < report[i] != inc {
            break cnt
          }
          let diff = if inc {
            report[i] - report[i - 1]
          } else {
            report[i - 1] - report[i]
          }
          if diff < 1 || diff > 3 {
            break cnt
          }
        } else {
          cnt + 1
        }
      }
    },
  )
}

///|
fn almost_safe_report_count(reports : Array[Array[Int]]) -> Int {
  fn check(
    report : Array[Int],
    inc : Bool,
    begin : Int,
    has_bad : Bool
  ) -> Bool {
    for i = begin - 2, j = begin; j < report.length(); i = j, j = j + 1 {
      let good = if i < 0 {
        true
      } else if report[i] == report[j] || report[i] < report[j] != inc {
        false
      } else {
        let diff = if inc {
          report[j] - report[i]
        } else {
          report[i] - report[j]
        }
        diff >= 1 && diff <= 3
      }
      if not(good) {
        break not(has_bad) &&
          (check(report, inc, j, true) || check(report, inc, j + 1, true))
      }
    } else {
      true
    }
  }

  reports.fold(
    init=0,
    fn(cnt, report) {
      for inc in [false, true] {
        if check(report, inc, 0, false) {
          break cnt + 1
        }
      } else {
        cnt
      }
    },
  )
}

test {
  let reports = input!()
  assert_eq!(safe_report_count(reports), 660)
  assert_eq!(almost_safe_report_count(reports), 689)
}
