// --- Day 17: Chronospatial Computer ---
// https://adventofcode.com/2024/day/17

///|
fn input() -> (Array[Int64], String)! {
  let content = @fs.read_file_to_string!(path="input/day17.txt")
  let registers = []
  let mut program = ""
  for line in content.split("\n") {
    if line.is_blank() {
      continue
    }
    let i = line.last_index_of(": ") + 2
    let s = line.substring(start=i)
    if registers.length() < 3 {
      registers.push(@strconv.parse_int64!(s))
    } else {
      program = s
    }
  }
  (registers, program)
}

///| part 1
/// set debug = true to see what dose the program do
fn run(
  program : String,
  registers : Array[Int64],
  debug~ : Bool = false
) -> String {
  let (a, b, c) = (0, 1, 2)
  let log = StringBuilder::new()
  fn eval_combo_operand(operand : Int) -> Int64 {
    if debug {
      match operand {
        0..=3 as v => log.write_object(v)
        4..=6 as i => log.write_char("abc"[i - 4])
        _ => panic()
      }
    }
    match operand {
      0..=3 as v => v.to_int64()
      4..=6 as i => registers[i - 4]
      _ => panic()
    }
  }

  fn div(operand : Int, out_reg : Int) -> Int? {
    if debug {
      log.write_char("abc"[out_reg])
      log.write_string(" = a >> ")
    }
    registers[out_reg] = registers[a] >> eval_combo_operand(operand).to_int()
    None
  }

  let output = StringBuilder::new()
  let operations = [
    // 0 adv
    fn(operand : Int) -> Int? { div(operand, a) },
    // 1 bxl
    fn(operand : Int) -> Int? {
      if debug {
        log.write_string(
          "b = b ^ 0b\{(operand >> 2) & 0b1}\{(operand >> 1) & 0b1}\{operand & 0b1}",
        )
      }
      registers[b] = registers[b] ^ operand.to_int64()
      None
    },
    // 2 bst
    fn(operand : Int) -> Int? {
      if debug {
        log.write_string("b = ")
      }
      registers[b] = eval_combo_operand(operand) & 0b111
      if debug {
        log.write_string(" & 0b111")
      }
      None
    },
    // 3 jnz
    fn(operand : Int) -> Int? {
      if debug {
        log.write_string("jmp \{operand}")
      }
      match registers[a] {
        0 => None
        _ => Some(operand)
      }
    },
    // 4 bxc
    fn(_operand : Int) -> Int? {
      if debug {
        log.write_string("b = b ^ c")
      }
      registers[b] = registers[b] ^ registers[c]
      None
    },
    // 5 out
    fn(operand : Int) -> Int? {
      if debug {
        log.write_string("out (")
      }
      if not(output.is_empty()) {
        output.write_char(',')
      }
      output.write_object(eval_combo_operand(operand) & 0b111)
      if debug {
        log.write_string(" & 0b111)")
      }
      None
    },
    // 6 bdv
    fn(operand : Int) -> Int? { div(operand, b) },
    // 7 cdv
    fn(operand : Int) -> Int? { div(operand, c) },
  ]
  let tokens = program.split(",").map(fn(e) { e[0] - '0' }).collect()
  if debug {
    let bak = registers.copy()
    for ipointer = 0; ipointer != tokens.length(); ipointer = ipointer + 2 {
      log.write_string("\{ipointer}: ")
      let opcode = tokens[ipointer]
      let operand = tokens[ipointer + 1]
      operations[opcode](operand) |> ignore
      log.write_char('\n')
    }
    println(log.to_string())
    for i, v in bak {
      registers[i] = v
    }
    output.reset()
  }
  for ipointer = 0; ipointer != tokens.length(); {
    let opcode = tokens[ipointer]
    let operand = tokens[ipointer + 1]
    match operations[opcode](operand) {
      None => continue ipointer + 2
      Some(new_ipointer) => continue new_ipointer
    }
  }
  output.to_string()
}

///| part 2
fn lowest_a_to_output_itself(
  program : String,
  registers : Array[Int64]
) -> Int64 {
  // run the program with debug mode, I know the program is a loop,
  // each iteration outputs one char and divides the register A by 8
  run(program, registers, debug=true) |> ignore
  let nums = program.split(",").map(fn(e) { e[0] - '0' }).collect()
  let mut ans = (1L << 63) - 1
  fn dfs(i, a) {
    if i == -1 {
      if a < ans {
        ans = a
      }
      return
    }
    let base_a = a << 3
    for delta_a = 0L; delta_a < 8; delta_a = delta_a + 1 {
      let mut b = delta_a & 0b111
      b = b ^ 0b101
      let c = (base_a | delta_a) >> b.to_int()
      b = b ^ 0b110
      b = b ^ c
      b = b & 0b111
      if b.to_int() == nums[i] {
        dfs(i - 1, base_a | delta_a)
      }
    }
  }

  dfs(nums.length() - 1, 0L)
  ans
}

test {
  let (registers, program) = input!()
  assert_eq!(program.length(), 16 + 15) // the program must have 2*8 tokens
  assert_eq!(run(program, registers), "3,6,3,7,0,7,0,3,0")
  assert_eq!(lowest_a_to_output_itself(program, registers), 136904920099226)
}
