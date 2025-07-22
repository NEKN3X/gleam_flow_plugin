import flow/helper
import flow/plugin
import gleam/option.{None}

type Settings {
  Settings(projects: List(String))
}

pub fn main() {
  let projects = ["project1", "project2"]
  let settings = Settings(projects)
  let config = helper.create_config(settings, ["open_url"])
  {
    use plugin, _context <- helper.init(config)
    {
      use _query <- helper.query(plugin)
      [
        plugin.JSONRPCResponse(
          title: "Example Response",
          sub_title: None,
          glyph: None,
          ico_path: None,
          json_rpc_action: plugin.JSONRPCAction(
            method: "exampleMethod",
            parameters: plugin.StringListParam([]),
          ),
          context_data: None,
          score: None,
        ),
      ]
    }
    plugin
  }
  |> helper.run()
}
