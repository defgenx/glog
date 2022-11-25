import gleam/dynamic.{Dynamic}
import gleam/erlang/atom.{Atom}
import gleam/map.{Map}
import glog/level.{LevelConfig}

pub opaque type Config {
  Config(config: Map(Atom, Dynamic))
}

pub fn new(key: String, value: a) -> Config {
  Config(config: map.new())
}

pub fn set_level(c: Config, value: LevelConfig) {
  c.config
  |> map.insert(atom.create_from_string("level"), dynamic.from(value))
}
