import flow/helper
import flow/plugin
import gleam/option.{None}
import method/open_url
import settings

pub fn make_result(
  _query: plugin.Query,
  _settings: settings.Settings,
) -> List(plugin.JSONRPCResponse) {
  [
    plugin.JSONRPCResponse(
      title: "Example Response",
      sub_title: None,
      glyph: None,
      ico_path: None,
      json_rpc_action: helper.action(
        open_url.get_method(),
        "https://example.com",
      ),
      context_data: None,
      score: None,
    ),
  ]
}
