import flow/helper
import flow/plugin
import gleam/dynamic/decode

pub fn open_url() {
  helper.Method(
    name: "open_url",
    action: fn(url) {
      plugin.JSONRPCAction("open_url", [plugin.StringParam(url)])
    },
    handler: fn(plugin, params) {
      case decode.run(params, decode.list(decode.string)) {
        Ok([url]) -> helper.flow_method(plugin, helper.OpenUrl(url))
        _ -> Nil
      }
    },
  )
}

pub fn copy_text() {
  helper.Method(
    name: "copy_text",
    action: fn(text) {
      plugin.JSONRPCAction("copy_text", [plugin.StringParam(text)])
    },
    handler: fn(plugin, params) {
      case decode.run(params, decode.list(decode.string)) {
        Ok([text]) -> helper.flow_method(plugin, helper.CopyText(text))
        _ -> Nil
      }
    },
  )
}
