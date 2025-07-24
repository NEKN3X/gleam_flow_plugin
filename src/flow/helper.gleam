import flow/helper/context
import flow/helper/query
import flow/helper/result
import flow/plugin.{type FlowPlugin, send_request}
import gleam/dynamic
import gleam/dynamic/decode
import gleam/json
import gleam/list

pub fn create() {
  plugin.create()
}

pub fn init(
  plugin: FlowPlugin,
  f: fn(FlowPlugin, plugin.Context) -> FlowPlugin,
) -> FlowPlugin {
  {
    plugin.on_request(plugin, "initialize", fn(params) {
      let context = context.decode_context(params)
      case context {
        Ok(ctx) -> {
          f(plugin, ctx)
          json.object([])
        }
        Error(_) -> {
          flow_method(plugin, ShowMessage("Failed to decode context"))
          json.object([])
        }
      }
    })
  }
  plugin
}

pub fn query(
  plugin: FlowPlugin,
  settings_decoder: decode.Decoder(settings),
  f: fn(plugin.Query, settings) -> List(plugin.JSONRPCResponse),
) {
  plugin.on_query(plugin, "query", fn(q, s) {
    let assert Ok(query) = query.decode_query(q)
    let assert Ok(settings) = decode.run(s, settings_decoder)
    json.object([
      #("result", json.preprocessed_array(result.to_json(f(query, settings)))),
    ])
  })
  plugin
}

pub fn method(plugin: FlowPlugin, method: Method(a)) {
  plugin.on_request(plugin, method.name, fn(params) {
    method.handler(plugin, params)
    json.object([])
  })
  plugin
}

pub fn run(plugin: FlowPlugin) {
  plugin.listen(plugin)
}

pub type FlowPluginMethod {
  OpenUrl(String)
  OpenInPrivateWindow(String)
  ShowMessage(String)
  CopyText(String)
}

pub fn flow_method(plugin: FlowPlugin, method: FlowPluginMethod) {
  case method {
    OpenUrl(url) -> send_request(plugin, "OpenUrl", open_url(url, False))
    OpenInPrivateWindow(url) ->
      send_request(plugin, "OpenUrl", open_url(url, True))
    ShowMessage(title) -> send_request(plugin, "ShowMsg", show_message(title))
    CopyText(text) -> send_request(plugin, "CopyToClipboard", copy_text(text))
  }
}

fn open_url(url: String, private: Bool) {
  json.object(
    [#("url", json.string(url))]
    |> list.append(case private {
      True -> [#("inPrivate", json.bool(True))]
      False -> []
    }),
  )
}

fn show_message(title: String) {
  json.object([#("title", json.string(title))])
}

fn copy_text(text: String) {
  json.object([#("text", json.string(text))])
}

pub type Method(a) {
  Method(
    name: String,
    parameters: fn(a) -> plugin.Parameters,
    handler: fn(plugin.FlowPlugin, dynamic.Dynamic) -> Nil,
  )
}

pub fn action(method: Method(a), a) -> plugin.JSONRPCAction {
  plugin.JSONRPCAction(method: method.name, parameters: method.parameters(a))
}
