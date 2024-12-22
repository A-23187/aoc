// --- Day 22: Monkey Market ---
// https://adventofcode.com/2024/day/22

///|
fn input() -> Array[Int]! {
  let content = @fs.read_file_to_string!(path="input/day22.txt")
  let nums = []
  for line in content.split("\n") {
    nums.push(@strconv.parse_int!(line))
  }
  nums
}

///|
fn evolve(secret : Int64) -> Int64 {
  let mut v = secret
  v = ((v * 64) ^ v) % 16777216
  v = ((v / 32) ^ v) % 16777216
  v = ((v * 2048) ^ v) % 16777216
  v
}

///| part 1
fn sum_of_nth_secret_numbers(secrets : Array[Int], n~ : Int = 2000) -> Int64 {
  secrets.fold(init=0, fn(sum, secret) {
    for secret = secret.to_int64(), i = 0; i < n; {
      continue evolve(secret), i + 1
    } else {
      sum + secret
    }
  })
}

///| part 2
fn max_price(secrets : Array[Int], n~ : Int = 2000) -> Int {
  let prices = @hashmap.new()
  for secret in secrets {
    let keys = @hashset.new()
    let changes = []
    for secret = secret.to_int64(), i = 0; i < n; {
      let new_secret = evolve(secret)
      changes.push((new_secret % 10 - secret % 10).to_int())
      if changes.length() >= 4 {
        let n = changes.length()
        let key = (
          changes[n - 4],
          changes[n - 3],
          changes[n - 2],
          changes[n - 1],
        )
        if not(keys.contains(key)) {
          keys.add(key)
          prices[key] = prices.get_or_default(key, 0) +
            (new_secret % 10).to_int()
        }
      }
      continue new_secret, i + 1
    }
  }
  prices
  .iter()
  .fold(init=0, fn(max_price, key_price) {
    @math.maximum(max_price, key_price.1)
  })
}

test {
  let secrets = input!()
  assert_eq!(sum_of_nth_secret_numbers(secrets), 15613157363)
  assert_eq!(max_price(secrets), 1784)
}
