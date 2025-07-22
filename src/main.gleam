import flow/helper
import method/open_url
import query
import settings

pub fn main() {
  {
    use plugin, _context <- helper.init(helper.create())
    helper.query(plugin, settings.settings_decoder(), query.make_result)
    helper.method(plugin, open_url.get_method())
    plugin
  }
  |> helper.run()
}
