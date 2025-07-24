import flow/helper.{action}
import flow/plugin.{JSONRPCResponse}
import gleam/option.{None, Some}
import methods
import settings

pub fn make_result() {
  fn(query: plugin.Query, settings: settings.Settings) {
    [
      JSONRPCResponse(
        title: "Open URL Example",
        sub_title: Some("query: " <> query.search),
        glyph: None,
        ico_path: None,
        json_rpc_action: action(methods.open_url(), "https://example.com"),
        context_data: None,
        score: None,
      ),
      JSONRPCResponse(
        title: "Copy Text Example",
        sub_title: None,
        glyph: None,
        ico_path: None,
        json_rpc_action: action(methods.copy_text(), settings.sample),
        context_data: None,
        score: None,
      ),
    ]
  }
}
