// --- Day 1: Historian Hysteria ---
// https://adventofcode.com/2024/day/1

///|
fn input() -> (Array[Int], Array[Int])! {
  let nums1 : Array[Int] = []
  let nums2 : Array[Int] = []
  let content = @fs.read_file_to_string!(path="input/day01.txt")
  for line in content.split("\n") {
    let mut i = 0
    for item in line.split(" ") {
      if not(item.is_empty()) {
        let num = @strconv.parse_int!(item)
        i = i + 1
        if i == 1 {
          nums1.push(num)
        } else if i == 2 {
          nums2.push(num)
        }
      }
    }
  }
  (nums1, nums2)
}

///| part 1
fn total_distance(nums1 : Array[Int], nums2 : Array[Int]) -> Int {
  nums1.sort()
  nums2.sort()
  nums1.foldi(
    init=0,
    fn(i, acc, num) {
      if nums1[i] < nums2[i] {
        acc + nums2[i] - nums1[i]
      } else {
        acc + nums1[i] - nums2[i]
      }
    },
  )
}

///| part 2
fn total_similarity(nums1 : Array[Int], nums2 : Array[Int]) -> Int {
  let cnt : @hashmap.T[Int, Int] = @hashmap.new()
  for num in nums2 {
    cnt[num] = cnt.get_or_default(num, 0) + 1
  }
  nums1.fold(init=0, fn(acc, num) { acc + num * cnt.get_or_default(num, 0) })
}

test {
  let tup = input!()
  assert_eq!(total_distance(tup.0, tup.1), 2970687)
  assert_eq!(total_similarity(tup.0, tup.1), 23963899)
}
