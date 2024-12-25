// --- Day 24: Crossed Wires ---
// https://adventofcode.com/2024/day/24

///|
fn input() -> (Array[(String, Int)], Array[(String, String, String, String)])! {
  let content = @fs.read_file_to_string!(path="input/day24.txt")
  let wires = []
  let gates = []
  let mut see_blank_line = false
  for line in content.split("\n") {
    if line.is_blank() {
      see_blank_line = true
      continue
    }
    if not(see_blank_line) {
      let i = line.index_of(": ")
      wires.push(
        (line.substring(start=0, end=i), line.substring(start=i + 2)[0] - '0'),
      )
    } else {
      let items = line.split(" ").collect()
      gates.push((items[0], items[1], items[2], items[4]))
    }
  }
  (wires, gates)
}

///| part 1
fn part1(
  wires : Array[(String, Int)],
  gates : Array[(String, String, String, String)]
) -> Int64 {
  fn eval(expr : (String, Int, Int)) -> Int {
    match expr {
      ("AND", a, b) => a & b
      ("OR", a, b) => a | b
      ("XOR", a, b) => a ^ b
      (opcode, _, _) => abort("Invalid opcode: \{opcode}.")
    }
  }

  let outnodes = @hashmap.new()
  let exprs = @hashmap.new()
  for gate in gates {
    let (a, opcode, b, c) = gate
    match outnodes[a] {
      None => outnodes[a] = [c]
      Some(nodes) => nodes.push(c)
    }
    match outnodes[b] {
      None => outnodes[b] = [c]
      Some(nodes) => nodes.push(c)
    }
    exprs[c] = (opcode, None, None)
  }
  let values = @hashmap.from_iter(wires.iter())
  let q = @queue.from_iter(wires.iter().map(fn(wire) { wire.0 }))
  while not(q.is_empty()) {
    let i = q.pop().unwrap()
    for o in outnodes[i].or([]) {
      match exprs[o].unwrap() {
        (opcode, None, _) => exprs[o] = (opcode, values[i], None)
        (opcode, Some(a), _) => {
          let b = values[i].unwrap()
          exprs[o] = (opcode, Some(a), Some(b))
          values[o] = eval((opcode, a, b))
          q.push(o)
        }
      }
    }
  }
  values
  .iter()
  .fold(init=0, fn(ans, kv) {
    let (k, v) = kv
    if k.starts_with("z") {
      ans | (v.to_int64() << ((k[1] - '0') * 10 + (k[2] - '0')))
    } else {
      ans
    }
  })
}

///| part 2
fn part2(gates : Array[(String, String, String, String)]) -> String {
  fn normalize(a : String, b : String) {
    if a < b {
      (a, b)
    } else {
      (b, a)
    }
  }

  let exprs = @hashmap.new()
  let outputs = @hashmap.new()
  let swaps = []
  fn swap(out1 : String, out2 : String) -> Unit {
    swaps.push(out1)
    swaps.push(out2)
    let (expr1, expr2) = (exprs[out1].unwrap(), exprs[out2].unwrap())
    exprs[out1] = expr2
    exprs[out2] = expr1
    outputs[expr1] = out2
    outputs[expr2] = out1
  }

  let mut n = 0
  for gate in gates {
    let (a, opcode, b, c) = gate
    let expr = (opcode, normalize(a, b))
    exprs[c] = expr
    outputs[expr] = c
    if c.starts_with("z") {
      n = @math.maximum(n, (c[1] - '0') * 10 + (c[2] - '0'))
    }
  }
  for carry = "", i = 0; i < n; {
    let name = "\{i / 10}\{i % 10}"
    let x = "x\{name}"
    let y = "y\{name}"
    let z = "z\{name}"
    let x_and_y = outputs[("AND", normalize(x, y))].unwrap()
    let x_xor_y = outputs[("XOR", normalize(x, y))].unwrap()
    if carry == "" {
      if x_xor_y != z {
        swap(x_xor_y, z)
      }
      continue x_and_y, i + 1
    }
    let expr = ("XOR", normalize(x_xor_y, carry))
    match outputs[expr] {
      None => {
        let (_, (a, b)) = expr
        let (_, (c, d)) = exprs[z].unwrap()
        if a == c {
          swap(b, d)
        } else if a == d {
          swap(b, c)
        } else if b == c {
          swap(a, d)
        } else if b == d {
          swap(a, c)
        } else {
          panic()
        }
      }
      Some(o) => if o != z { swap(o, z) }
    }
    let x_and_y = outputs[("AND", normalize(x, y))].unwrap()
    let x_xor_y = outputs[("XOR", normalize(x, y))].unwrap()
    let mut new_carry = outputs[("AND", normalize(x_xor_y, carry))].unwrap()
    new_carry = outputs[("OR", normalize(x_and_y, new_carry))].unwrap()
    continue new_carry, i + 1
  }
  swaps.sort()
  swaps
  .fold(init=StringBuilder::new(), fn(sb, s) {
    if not(sb.is_empty()) {
      sb.write_char(',')
    }
    sb.write_string(s)
    sb
  })
  .to_string()
}

test {
  let (wires, gates) = input!()
  assert_eq!(part1(wires, gates), 36035961805936)
  assert_eq!(part2(gates), "jqf,mdd,skh,wpd,wts,z11,z19,z37")
}
