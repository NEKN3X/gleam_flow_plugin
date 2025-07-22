import flow/helper
import flow/plugin
import gleam/dynamic/decode
import gleam/list

pub fn get_method() {
  let decoder = {
    decode.list(decode.string)
    |> decode.map(list.first)
    |> decode.then(fn(url) {
      case url {
        Ok(u) -> decode.success(u)
        Error(_) -> decode.failure("", "Invalid URL")
      }
    })
  }
  let handler = fn(plugin, x) {
    helper.flow_method(plugin, helper.OpenUrl(x))
    Nil
  }
  helper.Method(
    "open_url",
    fn(url) { [plugin.StringParam(url)] },
    decoder,
    handler,
  )
}
