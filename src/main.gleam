import flow/helper

type Settings {
  Settings(projects: List(String))
}

pub fn main() {
  let projects = ["project1", "project2"]
  let settings = Settings(projects)
  let config = helper.create_config(settings, ["open_url"])
  {
    use plugin, context <- helper.init(config)
    plugin
  }
  |> helper.run()
}
