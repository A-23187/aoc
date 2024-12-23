// --- Day 23: LAN Party ---
// https://adventofcode.com/2024/day/23

///|
fn input() -> Array[(String, String)]! {
  let content = @fs.read_file_to_string!(path="input/day23.txt")
  let edges = []
  for line in content.split("\n") {
    let items = line.split("-").collect()
    edges.push((items[0], items[1]))
  }
  edges
}

///| part 1
fn count_triplets_containing_t_computer(edges : Array[(String, String)]) -> Int {
  let neighbors = @hashmap.new()
  for edge in edges {
    let (a, b) = edge
    match neighbors[a] {
      None => neighbors[a] = @hashset.of([b])
      Some(s) => s.add(b)
    }
    match neighbors[b] {
      None => neighbors[b] = @hashset.of([a])
      Some(s) => s.add(a)
    }
  }
  let triplets = @hashset.new()
  for edge in edges {
    let (a, b) = edge
    if a[0] == 't' || b[0] == 't' {
      for c in neighbors[a].unwrap().intersection(neighbors[b].unwrap()) {
        let t = [a, b, c]
        t.sort()
        triplets.add((t[0], t[1], t[2]))
      }
    }
  }
  triplets.size()
}

///| part 2
fn password_of_lan_party(edges : Array[(String, String)]) -> String {
  let neighbors = @hashmap.new()
  fn n(v : String) -> @hashset.T[String] {
    match neighbors[v] {
      None => @hashset.new()
      Some(s) => s
    }
  }

  // https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
  // algorithm BronKerbosch1(R, P, X) is
  //     if P and X are both empty then
  //         report R as a maximal clique
  //     for each vertex v in P do
  //         BronKerbosch1(R ⋃ {v}, P ⋂ N(v), X ⋂ N(v))
  //         P := P \ {v}
  //         X := X ⋃ {v}
  let mut max_clique = @hashset.new()
  fn bron_kerbosch(
    r : @hashset.T[String],
    p : @hashset.T[String],
    x : @hashset.T[String]
  ) -> Unit {
    if p.is_empty() && x.is_empty() {
      if r.size() > max_clique.size() {
        max_clique = r
      }
      return
    }
    let u = p.union(x).iter().peek().unwrap()
    for v in p.difference(n(u)) {
      bron_kerbosch(
        r.union(@hashset.of([v])),
        p.intersection(n(v)),
        x.intersection(n(v)),
      )
      p.remove(v)
      x.add(v)
    }
  }

  let r = @hashset.new()
  let p = @hashset.new()
  let x = @hashset.new()
  // init neighbors and p
  for edge in edges {
    let (a, b) = edge
    p.add(a)
    match neighbors[a] {
      None => neighbors[a] = @hashset.of([b])
      Some(s) => s.add(b)
    }
    p.add(b)
    match neighbors[b] {
      None => neighbors[b] = @hashset.of([a])
      Some(s) => s.add(a)
    }
  }
  bron_kerbosch(r, p, x)
  let nodes = max_clique.iter().collect()
  nodes.sort()
  nodes
  .fold(init=StringBuilder::new(), fn(sb, node) {
    if not(sb.is_empty()) {
      sb.write_char(',')
    }
    sb.write_string(node)
    sb
  })
  .to_string()
}

test {
  let edges = input!()
  assert_eq!(count_triplets_containing_t_computer(edges), 998)
  assert_eq!(
    password_of_lan_party(edges),
    "cc,ff,fh,fr,ny,oa,pl,rg,uj,wd,xn,xs,zw",
  )
}
