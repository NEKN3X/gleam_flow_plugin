import gleam/dict
import gleam/option.{type Option}
import jsonrpc

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

pub type Parameters {
  StringParam(String)
  IntParam(Int)
  BoolParam(Bool)
  RecordParam(dict.Dict(String, Parameters))
  StringListParam(List(String))
  IntListParam(List(Int))
  BoolListParam(List(Bool))
  RecordListParam(List(dict.Dict(String, Parameters)))
  EmptyParam
}

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

pub type FlowPluginConfig(a, b) {
  FlowPluginConfig(settings: a, methods: b)
}

pub type FlowPlugin(a, b) {
  FlowPlugin(
    connection: jsonrpc.MessageConnection,
    config: FlowPluginConfig(a, b),
  )
}

pub fn clone(plugin: FlowPlugin(_, _)) {
  FlowPlugin(connection: plugin.connection, config: plugin.config)
}

pub fn create(config: FlowPluginConfig(_, _)) {
  FlowPlugin(connection: jsonrpc.create_default_connection(), config: config)
}

pub fn on_request(plugin: FlowPlugin(_, _), method, handler) {
  jsonrpc.on_request(plugin.connection, method, handler)
}

pub fn send_request(plugin: FlowPlugin(_, _), method, params) {
  jsonrpc.send_request(plugin.connection, method, params)
}

pub fn listen(plugin: FlowPlugin(_, _)) {
  jsonrpc.listen(plugin.connection)
}
