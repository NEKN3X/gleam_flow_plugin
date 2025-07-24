import ffi/jsonrpc
import gleam/dict
import gleam/dynamic/decode
import gleam/option.{type Option}

pub type Metadata {
  Metadata(
    id: String,
    name: String,
    author: String,
    version: String,
    language: String,
    description: String,
    website: String,
    disabled: Bool,
    home_disabled: Bool,
    execute_file_path: String,
    execute_file_name: String,
    plugin_directory: String,
    action_keyword: String,
    action_keywords: List(String),
    hide_action_keyword_panel: Bool,
    ico_path: String,
    plugin_settings_directory_path: String,
    plugin_cache_directory_path: String,
  )
}

pub type Context {
  Context(metadata: Metadata)
}

pub type Query {
  Query(
    raw_query: String,
    is_re_query: Bool,
    is_home_query: Bool,
    search: String,
    search_terms: List(String),
    action_keyword: String,
  )
}

pub type Glyph {
  Glyph(glyph: String, font_family: String)
}

pub type ParametersAllowedTypes {
  StringParam(String)
  IntParam(Int)
  BoolParam(Bool)
  RecordParam(dict.Dict(String, ParametersAllowedTypes))
  StringListParam(List(String))
  IntListParam(List(Int))
  BoolListParam(List(Bool))
  RecordListParam(List(dict.Dict(String, ParametersAllowedTypes)))
}

pub type Parameters =
  List(ParametersAllowedTypes)

pub type JSONRPCAction {
  JSONRPCAction(method: String, parameters: Parameters)
}

pub type JSONRPCResponse {
  JSONRPCResponse(
    title: String,
    sub_title: Option(String),
    glyph: Option(Glyph),
    ico_path: Option(String),
    json_rpc_action: JSONRPCAction,
    context_data: Option(List(JSONRPCResponse)),
    score: Option(Int),
  )
}

pub type SearchPrecision {
  Fifty
  Twenty
  Zero
}

pub type MatchResult {
  MatchResult(
    score: Int,
    match_data: List(Int),
    raw_score: Int,
    search_precision: SearchPrecision,
    success: Int,
  )
}

pub type FlowPluginConfig(a) {
  FlowPluginConfig(settings: a, decoder: decode.Decoder(a))
}

pub type FlowPlugin {
  FlowPlugin(connection: jsonrpc.MessageConnection)
}

pub fn create() {
  FlowPlugin(connection: jsonrpc.create_default_connection())
}

pub fn on_request(plugin: FlowPlugin, method, handler) {
  jsonrpc.on_request(plugin.connection, method, handler)
}

pub fn on_query(plugin: FlowPlugin, method, handler) {
  jsonrpc.on_query(plugin.connection, method, handler)
}

pub fn send_request(plugin: FlowPlugin, method, params) {
  jsonrpc.send_request(plugin.connection, method, params)
}

pub fn listen(plugin: FlowPlugin) {
  jsonrpc.listen(plugin.connection)
}
