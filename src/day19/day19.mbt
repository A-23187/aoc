// --- Day 19: Linen Layout ---
// https://adventofcode.com/2024/day/19

///|
fn input() -> (Array[String], Array[String])! {
  let content = @fs.read_file_to_string!(path="input/day19.txt")
  let mut patterns = []
  let designs = []
  let mut see_blank_line = false
  for line in content.split("\n") {
    if line.is_blank() {
      see_blank_line = true
      continue
    }
    if not(see_blank_line) {
      patterns = line.split(", ").collect()
    } else {
      designs.push(line)
    }
  }
  (patterns, designs)
}

///|
let index : @hashmap.T[Char, Int] = @hashmap.of([
  ('w', 0),
  ('u', 1),
  ('b', 2),
  ('r', 3),
  ('g', 4),
])

///|
struct TrieNode {
  children : Array[TrieNode?]
  mut end : Bool
}

///|
fn TrieNode::new() -> TrieNode {
  { children: Array::make(5, None), end: false }
}

///|
fn TrieNode::insert(self : TrieNode, word : String) -> Unit {
  let mut p = self
  for ch in word {
    let i = index[ch].unwrap()
    p = match p.children[i] {
      Some(q) => q
      None => {
        let q = TrieNode::new()
        p.children[i] = Some(q)
        q
      }
    }
  }
  p.end = true
}

///|
fn TrieNode::make(words : Array[String]) -> TrieNode {
  words.fold(init=TrieNode::new(), fn(root, word) {
    root.insert(word)
    root
  })
}

///| part 1
fn number_of_possible_designs(
  patterns : Array[String],
  designs : Array[String]
) -> Int {
  let root = TrieNode::make(patterns)
  let cache = @hashmap.new()
  fn dfs(design : String, start : Int) -> Bool {
    let suf = design.substring(start~)
    if cache.contains(suf) {
      return cache[suf].unwrap()
    }
    if start == design.length() {
      return true
    }
    for p = root, i = start; i < design.length(); {
      let idx = index[design[i]].unwrap()
      match p.children[idx] {
        Some({ end: true, .. } as q) => {
          if dfs(design, i + 1) {
            cache[suf] = true
            break true
          }
          continue q, i + 1
        }
        Some(q) => continue q, i + 1
        None => {
          cache[suf] = false
          break false
        }
      }
    } else {
      cache[suf] = p.end
      p.end
    }
  }

  designs.fold(init=0, fn(cnt, design) {
    if dfs(design, 0) {
      cnt + 1
    } else {
      cnt
    }
  })
}

///| part 2
fn number_of_ways_to_make_all_designs(
  patterns : Array[String],
  designs : Array[String]
) -> Int64 {
  let root = TrieNode::make(patterns)
  let cache = @hashmap.new()
  fn dfs(design : String, start : Int) -> Int64 {
    let suf = design.substring(start~)
    if cache.contains(suf) {
      return cache[suf].unwrap()
    }
    if start == design.length() {
      return 1
    }
    for p = root, i = start, cnt = 0L; i < design.length(); {
      let idx = index[design[i]].unwrap()
      match p.children[idx] {
        Some({ end: true, .. } as q) =>
          continue q, i + 1, cnt + dfs(design, i + 1)
        Some(q) => continue q, i + 1, cnt
        None => {
          cache[suf] = cnt
          break cnt
        }
      }
    } else {
      cache[suf] = cnt
      cnt
    }
  }

  designs.fold(init=0, fn(cnt, design) { cnt + dfs(design, 0) })
}

test {
  let (patterns, designs) = input!()
  assert_eq!(number_of_possible_designs(patterns, designs), 353)
  assert_eq!(
    number_of_ways_to_make_all_designs(patterns, designs),
    880877787214477,
  )
}
