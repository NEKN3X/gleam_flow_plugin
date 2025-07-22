import gleam/dynamic.{type Dynamic}
import gleam/json.{type Json}

pub type MessageConnection

@external(javascript, "./ffi/jsonrpc_ffi.mjs", "createDefaultConnection")
pub fn create_default_connection() -> MessageConnection

@external(javascript, "./ffi/jsonrpc_ffi.mjs", "onRequest")
pub fn on_request(
  connection: MessageConnection,
  method: String,
  handler: fn(Dynamic) -> Json,
) -> Nil

@external(javascript, "./ffi/jsonrpc_ffi.mjs", "onRequest")
pub fn on_query(
  connection: MessageConnection,
  method: String,
  handler: fn(Dynamic, Dynamic) -> Json,
) -> Nil

@external(javascript, "./ffi/jsonrpc_ffi.mjs", "sendRequest")
pub fn send_request(
  connection: MessageConnection,
  method: String,
  params: Json,
) -> Dynamic

@external(javascript, "./ffi/jsonrpc_ffi.mjs", "listen")
pub fn listen(connection: MessageConnection) -> Nil
