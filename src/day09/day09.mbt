// --- Day 9: Disk Fragmenter ---
// https://adventofcode.com/2024/day/9

///|
fn input() -> String! {
  let content = @fs.read_file_to_string!(path="input/day09.txt")
  content.trim_end(" \t\r\n")
}

///|
fn f(i : Int, n : Int, v : Int) -> Int64 {
  ((i + i + n - 1) * n / 2).to_int64() * v.to_int64()
}

///| part 1
fn checksum_after_compacting_file_blocks(disk : String) -> Int64 {
  let n = disk.length()
  if n < 3 {
    return 0
  }
  let mut sum = 0L
  let mut i = 1
  let mut vi = 0
  let mut j = n + n % 2 - 2
  let mut vj = (n - 1) / 2
  let mut k = disk[0] - '0'
  let mut cap = disk[i] - '0'
  let mut size = disk[j] - '0'
  while i < j {
    if cap >= size {
      sum = sum + f(k, size, vj)
      j = j - 2
      vj = vj - 1
      k = k + size
      cap = cap - size
      size = disk[j] - '0'
    } else {
      let m = if i + 1 < j { disk[i + 1] - '0' } else { size - cap }
      sum = sum + f(k, cap, vj) + f(k + cap, m, vi + 1)
      i = i + 2
      vi = vi + 1
      k = k + cap + m
      size = size - cap
      cap = disk[i] - '0'
    }
  }
  sum
}

///| part 2
fn checksum_after_compacting_whole_files(disk : String) -> Int64 {
  let n = disk.length()
  let spans = []
  for i = 1, k = disk[0] - '0'
      i < n
      i = i + 2, k = k + (disk[i] - '0') + (disk[i + 1] - '0') {
    spans.push((k, disk[i] - '0'))
  } else {
    spans.push((k, -1))
  }
  let mut sum = 0L
  for i = n + n % 2 - 2, v = (n - 1) / 2; i > 0; i = i - 2, v = v - 1 {
    let size = disk[i] - '0'
    for j = 0; 2 * j + 1 < i; j = j + 1 {
      let (k, cap) = spans[j]
      if cap >= size {
        sum = sum + f(k, size, v)
        spans[j] = (k + size, cap - size)
        break
      }
    } else {
      let (k, cap) = spans[j - 1]
      sum = sum + f(k + cap, size, v)
    }
  }
  sum
}

test {
  let disk = input!()
  assert_eq!(checksum_after_compacting_file_blocks(disk), 6288599492129)
  assert_eq!(checksum_after_compacting_whole_files(disk), 6321896265143)
}
