{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')
promise = require('bluebird')
uid = require('uid')
os = require('os')
shelljs = require('shelljs')

execStdIn = (cmd, stdin) ->
  dname = os.tmpdir()
  filename = "#{dname}/#{uid(8)}"
  stdin.to("#{filename}.in")
  console.log stdin
  command = "< #{filename}.in #{cmd} > #{filename}.out"
  console.log command
  return new promise (resolve, reject) ->
    shelljs.exec command, (code, output) ->
      if code == 0
        resolve(shelljs.cat("#{filename}.out"))
      else
        console.error(output)
        reject(code)

parseWithCmdThroughStdin = (cmd, language) ->
  return (editor) ->
    if editor.getGrammar()?.scopeName is language
      execStdIn(cmd, editor.getText()).then (newText) ->
        editor.setText(newText)

registerOnSave = (doIt, plugin) ->

  onSave = () ->
    if atom.config.get("#{plugin._package_name}.onSave")
      doIt(atom.workspace.activePaneItem)

  Subscriber.extend(plugin)

  atom.workspace.eachEditor (editor) ->
    buffer = editor.getBuffer()
    plugin.unsubscribe(buffer)
    plugin.subscribe(buffer, 'saved', _.debounce(onSave, 50))

registerCommand = (name, doIt, plugin) ->
  atom.commands.add('atom-workspace', "#{plugin._package_name}:#{name}", doit)


module.exports = {
  execStdIn: execStdIn
  registerOnSave: registerOnSave
  registerCommand: registerCommand
  parseWithCmdThroughStdin: parseWithCmdThroughStdin
}
