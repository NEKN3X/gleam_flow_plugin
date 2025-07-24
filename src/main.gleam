import flow/helper
import methods
import query
import settings

pub fn main() {
  {
    use plugin, _context <- helper.init(helper.create())
    plugin
    |> helper.query(settings.settings_decoder(), query.make_result())
    |> helper.method(methods.open_url())
    |> helper.method(methods.copy_text())
  }
  |> helper.run()
}
