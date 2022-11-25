import gleam/erlang/atom.{Atom}
import gleam/map.{Map}
import gleam/list
import gleam/dynamic.{Dynamic}
import glog/arg.{Arg, Args}
import glog/field.{Field, Fields}
import glog/config.{Config}
import glog/level.{
  Alert, Critical, Debug, Emergency, Error, Info, Level, Notice, Warning,
}

pub opaque type Glog {
  Glog(fields: Map(Atom, Dynamic))
}

pub fn new() -> Glog {
  set_default_config()
  Glog(fields: map.new())
}

pub fn add(logger: Glog, key: String, value: any) -> Glog {
  Glog(
    logger.fields
    |> map.insert(atom.create_from_string(key), dynamic.from(value)),
  )
}

pub fn add_field(logger: Glog, f: Field) -> Glog {
  Glog(
    logger.fields
    |> map.insert(atom.create_from_string(field.key(f)), field.value(f)),
  )
}

pub fn add_fields(logger: Glog, f: Fields) -> Glog {
  Glog(fields: map.merge(logger.fields, fields_to_dynamic(f)))
}

pub fn emergency(logger: Glog, message: String) -> Glog {
  log(logger, Emergency, message)
}

pub fn emergencyf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Emergency, string, values)
}

pub fn alert(logger: Glog, message: String) -> Glog {
  log(logger, Alert, message)
}

pub fn alertf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Alert, string, values)
}

pub fn critical(logger: Glog, message: String) -> Glog {
  log(logger, Critical, message)
}

pub fn criticalf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Critical, string, values)
}

pub fn error(logger: Glog, message: String) -> Glog {
  log(logger, Error, message)
}

pub fn errorf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Error, string, values)
}

pub fn warning(logger: Glog, message: String) -> Glog {
  log(logger, Warning, message)
}

pub fn warningf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Warning, string, values)
}

pub fn info(logger: Glog, message: String) -> Glog {
  log(logger, Info, message)
}

pub fn infof(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Info, string, values)
}

pub fn notice(logger: Glog, message: String) -> Glog {
  log(logger, Notice, message)
}

pub fn noticef(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Notice, string, values)
}

pub fn debug(logger: Glog, message: String) -> Glog {
  log(logger, Debug, message)
}

pub fn debugf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Debug, string, values)
}

fn log(logger: Glog, level: Level, message: String) -> Glog {
  let new_logger =
    logger
    |> add("msg", message)
  log_string_with_fields(level, new_logger.fields)

  Glog(fields: map.new())
}

fn logf(logger: Glog, level: Level, string: String, values: Args) -> Glog {
  let new_logger =
    logger
    |> add("msg", sprintf(string, args_to_dynamic(values)))
  log_string_with_fields(level, new_logger.fields)

  Glog(fields: map.new())
}

fn args_to_dynamic(args: Args) -> List(Dynamic) {
  let Args(largs) = args
  largs
  |> list.map(fn(a) { dynamic.from(arg.value(a)) })
}

fn fields_to_dynamic(fields: Fields) -> Map(Atom, Dynamic) {
  let Fields(lfields) = fields
  map.from_list(
    lfields
    |> list.map(fn(f) {
      #(atom.create_from_string(field.key(f)), field.value(f))
    }),
  )
}

fn set_default_config() {
  set_handler_config(
    atom.create_from_string("default"),
    atom.create_from_string("formatter"),
    dynamic.from(#(
      dynamic.from(atom.create_from_string("logger_formatter")),
      dynamic.from(map.from_list([
        #(
          atom.create_from_string("single_line"),
          atom.create_from_string("true"),
        ),
        #(
          atom.create_from_string("legacy_header"),
          atom.create_from_string("false"),
        ),
      ])),
    )),
  )
}

external fn log_string_with_fields(Level, Map(Atom, Dynamic)) -> Nil =
  "logger" "log"

external fn log_string_with_list_map(
  Level,
  String,
  List(Dynamic),
  Map(Atom, Dynamic),
) -> Nil =
  "logger" "log"

external fn set_primary_config(Config) -> Nil =
  "logger" "set_primary_config"

external fn set_handler_config(Atom, Atom, Dynamic) -> Nil =
  "logger" "set_handler_config"

external fn add_handler(Atom, Atom, Dynamic) -> Nil =
  "logger" "add_handler"

external fn set_primary_config_key(Atom, Dynamic) -> Nil =
  "logger" "set_primary_config"

external fn get_handler_ids() -> List(Atom) =
  "logger" "get_handler_ids"

external fn get_handler_config(Atom) -> Dynamic =
  "logger" "get_handler_config"

external fn remove_handler(Atom) -> Nil =
  "logger" "remove_handler"

external fn sprintf(String, List(Dynamic)) -> Nil =
  "io_lib" "format"
