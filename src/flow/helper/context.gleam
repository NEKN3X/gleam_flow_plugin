import flow/plugin
import gleam/dynamic/decode

pub fn decode_context(data) {
  let decoder = {
    let meta = "currentPluginMetadata"
    use id <- decode.subfield([meta, "id"], decode.string)
    use name <- decode.subfield([meta, "name"], decode.string)
    use author <- decode.subfield([meta, "author"], decode.string)
    use version <- decode.subfield([meta, "version"], decode.string)
    use language <- decode.subfield([meta, "language"], decode.string)
    use description <- decode.subfield([meta, "description"], decode.string)
    use website <- decode.subfield([meta, "website"], decode.string)
    use disabled <- decode.subfield([meta, "disabled"], decode.bool)
    use home_disabled <- decode.subfield([meta, "homeDisabled"], decode.bool)
    use execute_file_path <- decode.subfield(
      [meta, "executeFilePath"],
      decode.string,
    )
    use execute_file_name <- decode.subfield(
      [meta, "executeFileName"],
      decode.string,
    )
    use plugin_directory <- decode.subfield(
      [meta, "pluginDirectory"],
      decode.string,
    )
    use action_keyword <- decode.subfield(
      [meta, "actionKeyword"],
      decode.string,
    )
    use action_keywords <- decode.subfield(
      [meta, "actionKeywords"],
      decode.list(decode.string),
    )
    use hide_action_keyword_panel <- decode.subfield(
      [meta, "hideActionKeywordPanel"],
      decode.bool,
    )
    use ico_path <- decode.subfield([meta, "icoPath"], decode.string)
    use plugin_settings_directory_path <- decode.subfield(
      [meta, "pluginSettingsDirectoryPath"],
      decode.string,
    )
    use plugin_cache_directory_path <- decode.subfield(
      [meta, "pluginCacheDirectoryPath"],
      decode.string,
    )
    decode.success(
      plugin.Context(plugin.Metadata(
        id,
        name,
        author,
        version,
        language,
        description,
        website,
        disabled,
        home_disabled,
        execute_file_path,
        execute_file_name,
        plugin_directory,
        action_keyword,
        action_keywords,
        hide_action_keyword_panel,
        ico_path,
        plugin_settings_directory_path,
        plugin_cache_directory_path,
      )),
    )
  }
  decode.run(data, decoder)
}
