import gleam/dynamic.{Dynamic}

pub type Args {
  Args(List(Arg))
}

pub opaque type Arg {
  Arg(value: Dynamic)
}

pub fn value(field: Arg) -> Dynamic {
  field.value
}

pub fn new(value: a) -> Arg {
  Arg(dynamic.from(value))
}
