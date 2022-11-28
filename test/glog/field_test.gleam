import gleeunit/should
import glog/field
import gleam/dynamic

pub fn key_value_test() {
  let field = field.new("foo", "bar")

  field
  |> field.key()
  |> should.equal("foo")

  field
  |> field.value()
  |> should.equal(dynamic.from("bar"))
}
