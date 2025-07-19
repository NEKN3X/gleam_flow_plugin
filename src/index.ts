import process from 'node:process'
import * as rpc from 'vscode-jsonrpc/node.js'

const connection = rpc.createMessageConnection(
  new rpc.StreamMessageReader(process.stdin),
  new rpc.StreamMessageWriter(process.stdout),
)

connection.onRequest('initialize', () => {
  return {}
})

connection.onRequest('query', () => {
  return {}
})

connection.listen()
