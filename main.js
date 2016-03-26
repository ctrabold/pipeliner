var Elm = require("./Pipeliner.elm");

var app = Elm.fullscreen(Elm.Pipeliner, { currentCode: "" });

window.define = window.define || ace.define;
var editor = ace.edit("editor");
editor.setTheme("ace/theme/monokai")
editor.getSession().setMode("ace/mode/javascript");

document.getElementById("commit").addEventListener("click", function () {
  var currentCode = editor.getValue();
  if (currentCode.trim()) {
    app.ports.currentCode.send(currentCode);
  }
}, false);

