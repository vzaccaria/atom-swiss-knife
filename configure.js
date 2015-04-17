var {
  generateProject
} = require('diy-build')

generateProject(_ => {
  "use strict"
  _.collect("all", _ => {
    _.cmd("./node_modules/.bin/verb")
  })

  _.collect("update", _ => {
    _.cmd("babel configure.js | node")
  })
})