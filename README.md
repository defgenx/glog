# glog

[![Package Version](https://img.shields.io/hexpm/v/glog)](https://hex.pm/packages/glog)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glog/)

A Gleam implementation of Erlang logger inspired from [Logrus](https://github.com/sirupsen/logrus) API.

![](assets/small_glog_logo.png)


## Task List
- [x] Write documentation
- [ ] Add unit tests
- [ ] Improve API with `add_error`, `add_result` `add_option`...
- [ ] Add an API to configure the logger easier and deeper

## Usage
```gleam
 import glog.{Glog}
 import glog/field
 import glog/arg

 let logger: Glog = glog.new()
 
 // Set recommended default config
 glog.set_default_config()
 
 // Add value and a field to log
 // Print Info with template
 logger
 |> add("foo", "bar")
 |> add_field(field.new("woo", "zoo"))
 |> infof("I'll be ~p", [arg.new("back")])

```


## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

## Installation

This package can be added to your Gleam project:

```sh
gleam add glog
```

and its documentation can be found at <https://hexdocs.pm/glog>.
