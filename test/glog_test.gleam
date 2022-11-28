import gleeunit
import gleeunit/should
import glog
import glog/field

pub fn main() {
  gleeunit.main()
}

pub fn has_field_test() {
  glog.new()
  |> glog.has_field("foo")
  |> should.be_false()
}

pub fn get_field_test() {
  glog.new()
  |> glog.get_field("foo")
  |> should.be_error()
}

pub fn add_not_empty_test() {
  glog.new()
  |> glog.add("foo", "bar")
  |> glog.has_field("foo")
  |> should.be_true()
}

pub fn add_field_not_empty_test() {
  glog.new()
  |> glog.add_field(field.new("foo", "bar"))
  |> glog.has_field("foo")
  |> should.be_true()
}

pub fn add_fields_not_empty_test() {
  glog.new()
  |> glog.add_fields([field.new("foo", "bar"), field.new("woo", "zoo")])
  |> glog.has_field("woo")
  |> should.be_true()
}

pub fn add_and_add_field_equality_test() {
  glog.new()
  |> glog.add_field(field.new("foo", "bar"))
  |> should.equal(
    glog.new()
    |> glog.add("foo", "bar"),
  )
}

pub fn add_fields_and_add_field_equality_test() {
  glog.new()
  |> glog.add_fields([field.new("foo", "bar")])
  |> should.equal(
    glog.new()
    |> glog.add_field(field.new("foo", "bar")),
  )
}
