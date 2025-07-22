import gleam/dynamic/decode

pub type Settings {
  Settings(sample: String)
}

pub fn settings_decoder() {
  use sample <- decode.field("sample", decode.string)
  decode.success(Settings(sample))
}
