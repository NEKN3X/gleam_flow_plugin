import gleam/dynamic
import jsonrpc

pub fn main() -> Nil {
  let connection = jsonrpc.create_default_connection()
  jsonrpc.on_request(connection, "initialize", fn(_) { dynamic.properties([]) })
  jsonrpc.on_request(connection, "query", fn(_) { dynamic.properties([]) })
  jsonrpc.listen(connection)
}
