import gleeunit
import gleeunit/should
import glog
import glog/field
import gleam/option.{None, Some}

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

pub fn add_test() {
  glog.new()
  |> glog.add("foo", "bar")
  |> glog.has_field("foo")
  |> should.be_true()
}

pub fn add_field_test() {
  glog.new()
  |> glog.add_field(field.new("foo", "bar"))
  |> glog.has_field("foo")
  |> should.be_true()
}

pub fn add_fields_test() {
  glog.new()
  |> glog.add_fields([field.new("foo", "bar"), field.new("woo", "zoo")])
  |> glog.has_field("woo")
  |> should.be_true()
}

pub fn add_error_test() {
  glog.new()
  |> glog.add_error("foo")
  |> glog.has_field("error")
  |> should.be_true()
}

pub fn add_result_test() {
  glog.new()
  |> glog.add_result("foo", Ok("foo"))
  |> glog.has_field("foo")
  |> should.be_true()

  glog.new()
  |> glog.add_result("foo", Error("foo"))
  |> glog.has_field("error")
  |> should.be_true()

  glog.new()
  |> glog.add_result("foo", Error("foo"))
  |> glog.has_field("foo")
  |> should.be_false()
}

pub fn add_option_test() {
  glog.new()
  |> glog.add_option("foo", Some("foo"))
  |> glog.has_field("foo")
  |> should.be_true()

  glog.new()
  |> glog.add_option("foo", None)
  |> glog.has_field("foo")
  |> should.be_false()
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
