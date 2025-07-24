import flow/helper
import methods
import query
import settings

pub fn main() {
  {
    use plugin, _context <- helper.init(helper.create())
    helper.query(plugin, settings.settings_decoder(), query.make_result())
    helper.method(plugin, methods.open_url())
    helper.method(plugin, methods.copy_text())
    plugin
  }
  |> helper.run()
}
