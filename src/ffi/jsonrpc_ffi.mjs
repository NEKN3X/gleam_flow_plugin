import process from 'node:process'
import * as rpc from 'vscode-jsonrpc/node.js'

export function createDefaultConnection() {
  return rpc.createMessageConnection(
    new rpc.StreamMessageReader(process.stdin),
    new rpc.StreamMessageWriter(process.stdout),
  )
}

export function onRequest(connection, method, handler) {
  connection.onRequest(method, handler)
}

export function sendRequest(connection, method, params) {
  return connection.sendRequest(method, params)
}

export function listen(connection) {
  connection.listen()
}
