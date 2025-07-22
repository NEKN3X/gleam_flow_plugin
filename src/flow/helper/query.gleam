import flow/plugin
import gleam/dynamic/decode

pub fn decode_query(data) {
  let decoder = {
    use raw_query <- decode.field("rawQuery", decode.string)
    use is_re_query <- decode.field("isReQuery", decode.bool)
    use is_home_query <- decode.field("isHomeQuery", decode.bool)
    use search <- decode.field("search", decode.string)
    use search_terms <- decode.field("searchTerms", decode.list(decode.string))
    use action_keyword <- decode.field("actionKeyword", decode.string)
    decode.success(plugin.Query(
      raw_query,
      is_re_query,
      is_home_query,
      search,
      search_terms,
      action_keyword,
    ))
  }
  decode.run(data, decoder)
}
