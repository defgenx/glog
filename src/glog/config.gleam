import gleam/dynamic.{Dynamic}
import gleam/erlang/atom.{Atom}
import gleam/map.{Map}
import glog/level.{ConfigLevel}

/// Config opaque representation
pub opaque type Config {
  Config(config: Map(Atom, Dynamic))
}

/// Initializes a new Config
pub fn new(key: String, value: a) -> Config {
  Config(config: map.new())
}

/// Sets level in config struct
pub fn set_level(c: Config, value: ConfigLevel) {
  c.config
  |> map.insert(atom.create_from_string("level"), dynamic.from(value))
}
