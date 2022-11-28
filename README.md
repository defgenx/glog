# glog

[![Package Version](https://img.shields.io/hexpm/v/glog)](https://hex.pm/packages/glog)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glog/)

A Gleam implementation of Erlang logger inspired from [Logrus](https://github.com/sirupsen/logrus) API.

![](assets/small_glog_logo.png)

## Task List

- [x] Write documentation
- [x] Add unit tests
- [x] Improve API with `add_error`, `add_result` `add_option`...
- [ ] Add an API to configure the logger easier and deeper
- [ ] Implement various methodologies. Compute storage while adding, compute only on log emit or a hybrid mechanism.

## Usage

The Erlang logger is asynchronous by default, please read the [logger chapter](https://www.erlang.org/doc/apps/kernel/logger_chapter.html#message-queue-length)

```gleam
import gleam/io
import glog
import glog/field
import glog/arg
import glog/level


pub fn main() {
  let logger = glog.new()
  glog.set_primary_log_level(level.All)
  glog.set_default_config()

  logger
  |> glog.add("foo", "bar")
  |> glog.add_field(field.new("woo", "zoo"))
  |> glog.infof("I'll be ~p", [arg.new("back")])
}
```

## Things to know

* Gleam do not support configuration files at the moment. To load a custom Erlang config file use the following
  command: `ERL_FLAGS='-config <config_file>' gleam run`
    * Please read the [logger documentation](https://www.erlang.org/doc/man/logger.html) to know more about
      configuration files

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
