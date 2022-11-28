import gleam/dynamic.{Dynamic}

// Arg opaque representation
pub opaque type Arg {
  Arg(value: Dynamic)
}

// Fetches value from Arg
pub fn value(field: Arg) -> Dynamic {
  field.value
}

// Initializes a new Arg
pub fn new(value: a) -> Arg {
  Arg(dynamic.from(value))
}

// Type alias representing an Arg list
pub type Args =
  List(Arg)
