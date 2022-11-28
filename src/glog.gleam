import gleam/erlang/atom.{Atom}
import gleam/map.{Map}
import gleam/result
import gleam/list
import gleam/option.{None, Option, Some}
import gleam/dynamic.{Dynamic}
import glog/arg.{Args}
import glog/field.{Field, Fields}
import glog/level.{
  Alert, ConfigLevel, Critical, Debug, Emergency, Err, Info, Level, Notice,
  Warning,
}
import gleam/io

/// A Gleam implementation of Erlang logger
/// Glog is the current "state" of the log to print
pub opaque type Glog {
  Glog(fields: Map(Atom, Dynamic))
}

/// Initializes a new Glog representation
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
///
/// let logger: Glog = glog.new()
/// ```
pub fn new() -> Glog {
  Glog(fields: map.new())
}

/// Initializes a new Glog representation with fields
pub fn new_with(with: Option(Fields)) -> Glog {
  case with {
    Some(fields) ->
      new()
      |> add_fields(fields)
    None -> new()
  }
}

/// Finds if a field exists from its key
pub fn has_field(logger: Glog, key: String) -> Bool {
  map.has_key(logger.fields, atom.create_from_string(key))
}

/// Fetches a field if it exists from its key
pub fn get_field(logger: Glog, key: String) -> Result(Field, Nil) {
  logger.fields
  |> map.get(atom.create_from_string(key))
  |> result.map(fn(value) { field.new(key, value) })
}

/// Adds a key/value to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
///
/// let logger: Glog = glog.new()
/// logger
/// |> add("foo", "bar")
/// |> add("woo", "zoo")
/// ```
pub fn add(logger: Glog, key: String, value: any) -> Glog {
  Glog(
    logger.fields
    |> map.insert(atom.create_from_string(key), dynamic.from(value)),
  )
}

/// Adds a Field to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
/// import glog/field
///
/// let logger: Glog = glog.new()
/// logger
/// |> add_field(field.new("foo", "bar"))
/// ```
pub fn add_field(logger: Glog, f: Field) -> Glog {
  Glog(
    logger.fields
    |> map.insert(atom.create_from_string(field.key(f)), field.value(f)),
  )
}

/// Adds a Result to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
/// import glog/field
///
/// let logger: Glog = glog.new()
/// logger
/// |> add_result("foo", Ok("foo"))
/// ```
pub fn add_result(logger: Glog, key: String, r: Result(a, b)) -> Glog {
  case r {
    Ok(v) ->
      logger
      |> add(key, v)

    Error(e) ->
      logger
      |> add_error(e)
  }
}

/// Adds an Option to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
/// import glog/field
///
/// let logger: Glog = glog.new()
/// logger
/// |> add_option("foo", Some("foo"))
/// ```
pub fn add_option(logger: Glog, key: String, o: Option(a)) -> Glog {
  case o {
    Some(v) ->
      logger
      |> add(key, v)
    None -> logger
  }
}

/// Adds an error key to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
/// import glog/field
///
/// let logger: Glog = glog.new()
/// logger
/// |> add_error("foo")
/// ```
pub fn add_error(logger: Glog, error: a) -> Glog {
  logger
  |> add("error", error)
}

/// Adds Fields to the current log
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
/// import glog/field
///
/// let logger: Glog = glog.new()
/// logger
/// |> add_fields([field.new("foo", "bar"), field.new("woo", "zoo")])
/// ```
pub fn add_fields(logger: Glog, f: Fields) -> Glog {
  Glog(fields: map.merge(logger.fields, fields_to_dynamic(f)))
}

/// Prints Emergency log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
///
/// let logger: Glog = glog.new()
/// logger
/// |> emergency("er")
/// ```
pub fn emergency(logger: Glog, message: String) -> Glog {
  log(logger, Emergency, message)
}

/// Prints Emergency log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
///
/// ### Usage
/// ```gleam
/// import glog.{Glog}
///
/// let logger: Glog = glog.new()
/// logger
/// |> emergencyf("~p is the new ~p", [arg.new("foo"), arg.new("bar")])
/// ```
pub fn emergencyf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Emergency, string, values)
}

/// Prints Alert log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn alert(logger: Glog, message: String) -> Glog {
  log(logger, Alert, message)
}

/// Prints Alert log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn alertf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Alert, string, values)
}

/// Prints Critical log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn critical(logger: Glog, message: String) -> Glog {
  log(logger, Critical, message)
}

/// Prints Critical log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn criticalf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Critical, string, values)
}

/// Prints Err log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn error(logger: Glog, message: String) -> Glog {
  log(logger, Err, message)
}

/// Prints Err log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn errorf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Err, string, values)
}

/// Prints Warning log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn warning(logger: Glog, message: String) -> Glog {
  log(logger, Warning, message)
}

/// Prints Warning log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn warningf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Warning, string, values)
}

/// Prints Info log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn info(logger: Glog, message: String) -> Glog {
  log(logger, Info, message)
}

/// Prints Info log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn infof(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Info, string, values)
}

/// Prints Notice log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn notice(logger: Glog, message: String) -> Glog {
  log(logger, Notice, message)
}

/// Prints Notice log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn noticef(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Notice, string, values)
}

/// Prints Debug log with current fields stored and the given message
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn debug(logger: Glog, message: String) -> Glog {
  log(logger, Debug, message)
}

/// Prints Debug log with current fields stored and the given message template and values
///
/// Calling this function return a new Glog. Old Glog can still be used.
pub fn debugf(logger: Glog, string: String, values: Args) -> Glog {
  logf(logger, Debug, string, values)
}

// Private function handling the print logic for any level
fn log(logger: Glog, level: Level, message: String) -> Glog {
  let new_logger =
    logger
    |> add("msg", message)
  log_with_fields(level, new_logger.fields)

  logger
}

// Private function handling the printf logic for any level
fn logf(logger: Glog, level: Level, string: String, values: Args) -> Glog {
  log(logger, level, sprintf(string, args_to_dynamic(values)))
}

// Transforms Args to a Dynamic list
fn args_to_dynamic(args: Args) -> List(Dynamic) {
  args
  |> list.map(fn(a) { dynamic.from(arg.value(a)) })
}

// Transforms Fields to a Atom/Dynamic map
fn fields_to_dynamic(fields: Fields) -> Map(Atom, Dynamic) {
  map.from_list(
    fields
    |> list.map(fn(f) {
      #(atom.create_from_string(field.key(f)), field.value(f))
    }),
  )
}

/// Sets log level for primary handler
pub fn set_primary_log_level(level: ConfigLevel) {
  set_primary_config_value(
    atom.create_from_string("level"),
    dynamic.from(level),
  )
}

/// Sets log level for given handler
pub fn set_handler_log_level(handler: String, level: ConfigLevel) {
  set_handler_config_value(
    atom.create_from_string(handler),
    atom.create_from_string("level"),
    dynamic.from(level),
  )
}

/// Sets a default formatter for default handler
///
/// This function is what we want to recommend as default format or the lib
pub fn set_default_config() {
  set_handler_config_value(
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

external fn log_with_fields(Level, Map(Atom, Dynamic)) -> Nil =
  "logger" "log"

external fn set_primary_config_value(Atom, Dynamic) -> Nil =
  "logger" "set_primary_config"

external fn set_handler_config_value(Atom, Atom, Dynamic) -> Nil =
  "logger" "set_handler_config"

external fn sprintf(String, List(Dynamic)) -> String =
  "io_lib" "format"
