import gleeunit/should
import glog/arg
import gleam/dynamic

pub fn value_test() {
  arg.new("foo")
  |> arg.value()
  |> should.equal(dynamic.from("foo"))
}
