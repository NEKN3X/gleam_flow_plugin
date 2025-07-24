import flow/helper.{action}
import flow/plugin
import gleam/option.{None}
import methods
import settings

pub fn make_result() {
  fn(_query: plugin.Query, _settings: settings.Settings) -> List(
    plugin.JSONRPCResponse,
  ) {
    [
      plugin.JSONRPCResponse(
        title: "Example Response",
        sub_title: None,
        glyph: None,
        ico_path: None,
        json_rpc_action: action(methods.open_url(), "https://example.com"),
        context_data: None,
        score: None,
      ),
    ]
  }
}
