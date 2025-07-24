import flow/helper
import flow/plugin
import gleam/dynamic/decode

pub fn open_url() {
  helper.Method(
    name: "open_url",
    parameters: fn(url) { [plugin.StringParam(url)] },
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
    parameters: fn(text) { [plugin.StringParam(text)] },
    handler: fn(plugin, params) {
      case decode.run(params, decode.list(decode.string)) {
        Ok([text]) -> helper.flow_method(plugin, helper.CopyText(text))
        _ -> Nil
      }
    },
  )
}
