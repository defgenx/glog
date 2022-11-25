import gleam/dynamic.{Dynamic}
import gleam/erlang/atom.{Atom}

pub type Fields {
  Fields(List(Field))
}

pub opaque type Field {
  Field(key: String, value: Dynamic)
}

pub fn key(field: Field) -> String {
  field.key
}

pub fn value(field: Field) -> Dynamic {
  field.value
}

pub fn new(key: String, value: a) -> Field {
  Field(key, dynamic.from(value))
}
