{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')
promise = require('bluebird')
uid = require('uid')
os = require('os')
shelljs = require('shelljs')

debug = require('debug')
debug.enable("sk:*")
debug.log = console.log.bind(console)
debug = debug("sk:index")


{ execStdIn, registerOnSave } = require('./utils')
{ parseWithCmdThroughStdin, registerCommand } = require('./utils')

markdown = "source.gfm"
pandoc = "pandoc  --read markdown --write markdown-simple_tables+pipe_tables-fenced_code_blocks-fenced_code_attributes"
doMarkdown = parseWithCmdThroughStdin(pandoc, markdown)

octave = "source.matlab"
octaveBeautifier = "octave-beautifier"
doMatlab = parseWithCmdThroughStdin(octaveBeautifier, octave)

plugin = module.exports

plugin.config =

    # Only if you want it to process after save && language enabled.
    onSave:    { type: 'boolean', default: true, description: "Format on save" }

plugin.name = "atom-swiss-knife"

plugin.activate = (state) ->


  debug("Activating")

  # Remember to add an entry to keymap.cson for each command
  registerCommand("toggle", (=> @toggle()), plugin)

  # Only if you want it to process after save && language enabled.
  registerOnSave(doMarkdown, plugin)
  registerOnSave(doMatlab, plugin)

plugin.deactivate = ->

plugin.toggle = ->
  doMarkdown(atom.workspace.activePaneItem)
