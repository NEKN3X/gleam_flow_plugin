import flow/plugin
import gleam/dynamic/decode.{bool, field, list, string, success}

pub fn decode_query(data) {
  let decoder = {
    use raw_query <- field("rawQuery", string)
    use is_re_query <- field("isReQuery", bool)
    use is_home_query <- field("isHomeQuery", bool)
    use search <- field("search", string)
    use search_terms <- field("searchTerms", list(string))
    use action_keyword <- field("actionKeyword", string)
    success(plugin.Query(
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
