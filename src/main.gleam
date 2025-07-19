import gleam/json
import jsonrpc

pub fn main() -> Nil {
  let connection = jsonrpc.create_default_connection()
  jsonrpc.on_request(connection, "initialize", fn(_) { json.object([]) })
  jsonrpc.on_request(connection, "query", fn(_) {
    json.object([
      #(
        "result",
        json.array(
          [
            [
              #("title", json.string("example")),
              #(
                "jsonRPCAction",
                json.object([
                  #("method", json.string("open_url")),
                  #(
                    "parameters",
                    json.array(
                      [[#("url", json.string("https://example.com"))]],
                      of: json.object,
                    ),
                  ),
                ]),
              ),
            ],
          ],
          of: json.object,
        ),
      ),
    ])
  })
  jsonrpc.listen(connection)
}
