import gleam/dynamic.{Dynamic}

// Field opaque representation
pub opaque type Field {
  Field(key: String, value: Dynamic)
}

// Fetches key from Field
pub fn key(field: Field) -> String {
  field.key
}

// Fetches value from Field
pub fn value(field: Field) -> Dynamic {
  field.value
}

// Initializes a new Field
pub fn new(key: String, value: a) -> Field {
  Field(key, dynamic.from(value))
}

// Type alias representing a Field list
pub type Fields =
  List(Field)
