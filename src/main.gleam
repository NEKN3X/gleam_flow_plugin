import flow/helper
import gleam/dynamic/decode
import method/open_url
import query

type Settings {
  // Settings(projects: List(String))
  Settings
}

fn settings_decoder() {
  // use projects <- decode.field("projects", decode.list(decode.string))
  // decode.success(Settings(projects))
  decode.success(Settings)
}

pub fn main() {
  {
    use plugin, _context <- helper.init(helper.create())
    helper.query(plugin, settings_decoder(), query.make_result)
    helper.method(plugin, open_url.get_method())
    plugin
  }
  |> helper.run()
}
