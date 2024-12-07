// --- Day 5: Print Queue ---
// https://adventofcode.com/2024/day/5

///|
fn input() -> (Array[Array[Int]], Array[Array[Int]])! {
  let arr1 = []
  let arr2 = []
  let content = @fs.read_file_to_string!(path="input/day05.txt")
  let mut sep = "|"
  for line in content.split("\n") {
    if line.is_blank() {
      sep = ","
      continue
    }
    let nums = []
    for item in line.split(sep) {
      nums.push(@strconv.parse_int!(item))
    }
    if sep == "|" {
      arr1.push(nums)
    }
    if sep == "," {
      arr2.push(nums)
    }
  }
  (arr1, arr2)
}

///|
fn correct(m : @hashmap.T[Int, @hashset.T[Int]], update : Array[Int]) -> Unit {
  // init indegree
  let indegree : @hashmap.T[Int, Int] = @hashmap.new()
  for u in update {
    indegree[u] = 0
  }
  for u in update {
    if not(m.contains(u)) {
      continue
    }
    for v in m[u].unwrap() {
      if not(indegree.contains(v)) {
        continue
      }
      indegree[v] = indegree[v].unwrap() + 1
    }
  }
  // init queue
  let q = @queue.new()
  indegree.each(fn(u, d) { if d == 0 { q.push(u) } })
  // update in place by topological sorting
  let mut i = 0
  while not(q.is_empty()) {
    let u = q.pop().unwrap()
    update[i] = u
    i = i + 1
    if not(m.contains(u)) {
      continue
    }
    for v in m[u].unwrap() {
      if not(indegree.contains(v)) {
        continue
      }
      indegree[v] = indegree[v].unwrap() - 1
      if indegree[v].unwrap() == 0 {
        q.push(v)
      }
    }
  }
}

///|
fn sum_of_middle_page_number(
  rules : Array[Array[Int]],
  updates : Array[Array[Int]],
  need_correct~ : Bool = false
) -> Int {
  let m : @hashmap.T[Int, @hashset.T[Int]] = @hashmap.new()
  for rule in rules {
    if not(m.contains(rule[0])) {
      m[rule[0]] = @hashset.new()
    }
    m[rule[0]].unwrap().add(rule[1])
  }
  updates.fold(
    init=0,
    fn(sum, update) {
      let s = @hashset.new()
      let correct = for u in update {
        if not(s.intersection(m.get_or_default(u, @hashset.new())).is_empty()) {
          if need_correct {
            correct(m, update)
          }
          break false
        }
        s.add(u)
      } else {
        true
      }
      if correct != need_correct {
        sum + update[update.length() / 2]
      } else {
        sum
      }
    },
  )
}

test {
  let tup = input!()
  assert_eq!(sum_of_middle_page_number(tup.0, tup.1), 5747)
  assert_eq!(sum_of_middle_page_number(tup.0, tup.1, need_correct=true), 5502)
}
