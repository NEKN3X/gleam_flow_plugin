import gleam/dynamic.{type Dynamic}
import gleam/json.{type Json}

// JSONRPCメッセージ接続のタイプ
pub type MessageConnection

// メッセージ接続を作成（stdin/stdoutを使用）
@external(javascript, "./ffi/jsonrpc_ffi.mjs", "createDefaultConnection")
pub fn create_default_connection() -> MessageConnection

// リクエストハンドラーを登録
@external(javascript, "./ffi/jsonrpc_ffi.mjs", "onRequest")
pub fn on_request(
  connection: MessageConnection,
  method: String,
  handler: fn(Dynamic) -> Json,
) -> Nil

// リクエストを送信
@external(javascript, "./ffi/jsonrpc_ffi.mjs", "sendRequest")
pub fn send_request(
  connection: MessageConnection,
  method: String,
  params: Json,
) -> Dynamic

// 接続をリッスン開始
@external(javascript, "./ffi/jsonrpc_ffi.mjs", "listen")
pub fn listen(connection: MessageConnection) -> Nil
