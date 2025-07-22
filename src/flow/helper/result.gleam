import flow/plugin
import gleam/function
import gleam/json.{
  type Json, array, bool, dict, int, object, preprocessed_array, string,
}
import gleam/list
import gleam/option.{None, Some}

fn param_to_json(param) {
  case param {
    plugin.StringParam(s) -> string(s)
    plugin.IntParam(n) -> int(n)
    plugin.BoolParam(b) -> bool(b)
    plugin.RecordParam(r) -> dict(r, function.identity, param_to_json)
    plugin.StringListParam(l) -> array(l, string)
    plugin.IntListParam(l) -> array(l, int)
    plugin.BoolListParam(l) -> array(l, bool)
    plugin.RecordListParam(l) ->
      array(l, fn(record) { dict(record, function.identity, param_to_json) })
  }
}

pub fn to_json(data: List(plugin.JSONRPCResponse)) -> List(Json) {
  use item <- list.map(data)
  let glyph = case item.glyph {
    Some(g) ->
      Some([#("glyph", string(g.glyph)), #("fontFamily", string(g.font_family))])
    None -> None
  }
  let parameters =
    preprocessed_array(list.map(item.json_rpc_action.parameters, param_to_json))
  let action =
    object([
      #("method", string(item.json_rpc_action.method)),
      #("parameters", parameters),
    ])
  let context_data = case item.context_data {
    Some(cd) -> Some(#("contextData", preprocessed_array(to_json(cd))))
    None -> None
  }
  object(
    [#("title", string(item.title)), #("jsonRPCAction", action)]
    |> list.append(
      [
        item.sub_title |> option.map(fn(x) { #("subTitle", string(x)) }),
        glyph |> option.map(fn(x) { #("glyph", object(x)) }),
        item.ico_path |> option.map(fn(x) { #("icoPath", string(x)) }),
        item.score |> option.map(fn(x) { #("score", int(x)) }),
        context_data,
      ]
      |> list.filter_map(Error),
    ),
  )
}
