import flow/helper/context
import flow/helper/query
import flow/helper/result
import flow/plugin.{
  type FlowPlugin, type FlowPluginConfig, FlowPluginConfig, send_request,
}
import gleam/json
import gleam/list

pub fn create_config(settings, methods) {
  FlowPluginConfig(settings, methods)
}

pub fn init(
  config: FlowPluginConfig(_, _),
  f: fn(FlowPlugin(_, _), plugin.Context) -> FlowPlugin(_, _),
) -> FlowPlugin(_, _) {
  let plugin = plugin.create(config)
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
  plugin: FlowPlugin(_, methods),
  f: fn(plugin.Query) -> List(plugin.JSONRPCResponse),
) {
  plugin.on_request(plugin, "query", fn(params) {
    let assert Ok(query) = query.decode_query(params)
    json.object([#("result", json.preprocessed_array(result.to_json(f(query))))])
  })
}

pub fn run(plugin: FlowPlugin(_, _)) {
  plugin.listen(plugin)
}

pub type FlowPluginMethod {
  OpenUrl(String)
  OpenInPrivateWindow(String)
  ShowMessage(String)
}

pub fn flow_method(plugin: FlowPlugin(_, _), method: FlowPluginMethod) {
  case method {
    OpenUrl(url) -> send_request(plugin, "OpenUrl", open_url(url, False))
    OpenInPrivateWindow(url) ->
      send_request(plugin, "OpenUrl", open_url(url, True))
    ShowMessage(title) -> send_request(plugin, "ShowMsg", show_message(title))
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
