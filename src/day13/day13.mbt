// --- Day 13: Claw Contraption ---
// https://adventofcode.com/2024/day/13

///|
fn input() -> Array[((Int, Int), (Int, Int), (Int, Int))]! {
  let content = @fs.read_file_to_string!(path="input/day13.txt")
  let machines = []
  let button_prize = []
  for line in content.split("\n") {
    if line.is_blank() {
      machines.push((button_prize[0], button_prize[1], button_prize[2]))
      button_prize.clear()
      continue
    }
    let ch = if button_prize.length() < 2 { "+" } else { "=" }
    let i = line.index_of(ch) + 1
    let j = line.index_of(",", from=i)
    let x = @strconv.parse_int!(line.substring(start=i, end=j))
    let y = @strconv.parse_int!(
      line.substring(start=line.index_of(ch, from=j) + 1),
    )
    button_prize.push((x, y))
  } else {
    machines.push((button_prize[0], button_prize[1], button_prize[2]))
  }
  machines
}

///| part 1: offset = 0, part 2: offset = 10000000000000
fn fewest_token_to_win(
  machines : Array[((Int, Int), (Int, Int), (Int, Int))],
  offset~ : Int64 = 0
) -> Int64 {
  machines.fold(
    init=0L,
    fn(cnt, machine) {
      let ((ax, ay), (bx, by), (x, y)) = machine
      let ((ax, ay), (bx, by), (x, y)) = (
        (ax.to_int64(), ay.to_int64()),
        (bx.to_int64(), by.to_int64()),
        (x.to_int64() + offset, y.to_int64() + offset),
      )
      let (au, av) = (x * by - y * bx, ax * by - ay * bx)
      let (bu, bv) = (x * ay - y * ax, bx * ay - by * ax)
      if au % av == 0 && bu % bv == 0 {
        cnt + 3L * au / av + bu / bv
      } else {
        cnt
      }
    },
  )
}

test {
  let machines = input!()
  assert_eq!(fewest_token_to_win(machines), 39748)
  assert_eq!(
    fewest_token_to_win(machines, offset=10000000000000),
    74478585072604,
  )
}
