import flow/plugin
import gleam/function
import gleam/json
import gleam/list
import gleam/option.{None, Some}

fn param_to_json(param) {
  case param {
    plugin.StringParam(s) -> json.string(s)
    plugin.IntParam(n) -> json.int(n)
    plugin.BoolParam(b) -> json.bool(b)
    plugin.RecordParam(r) -> json.dict(r, fn(s) { s }, param_to_json)
    plugin.StringListParam(l) -> json.array(l, json.string)
    plugin.IntListParam(l) -> json.array(l, json.int)
    plugin.BoolListParam(l) -> json.array(l, json.bool)
    plugin.RecordListParam(l) ->
      json.array(l, fn(record) {
        json.dict(record, function.identity, param_to_json)
      })
    plugin.EmptyParam -> json.object([])
  }
}

pub fn to_json(data: List(plugin.JSONRPCResponse)) -> List(json.Json) {
  use item <- list.map(data)
  let glyph = case item.glyph {
    Some(g) ->
      Some([
        #("glyph", json.string(g.glyph)),
        #("fontFamily", json.string(g.font_family)),
      ])
    None -> None
  }
  let parameters = param_to_json(item.json_rpc_action.parameters)
  let action =
    json.object([
      #("method", json.string(item.json_rpc_action.method)),
      #("parameters", parameters),
    ])
  let context_data = case item.context_data {
    Some(cd) -> Some(#("contextData", json.preprocessed_array(to_json(cd))))
    None -> None
  }
  json.object(
    [#("title", json.string(item.title)), #("jsonRPCAction", action)]
    |> list.append(
      [
        item.sub_title |> option.map(fn(x) { #("subTitle", json.string(x)) }),
        glyph |> option.map(fn(x) { #("glyph", json.object(x)) }),
        item.ico_path |> option.map(fn(x) { #("icoPath", json.string(x)) }),
        item.score |> option.map(fn(x) { #("score", json.int(x)) }),
        context_data,
      ]
      |> list.filter_map(Error),
    ),
  )
}
