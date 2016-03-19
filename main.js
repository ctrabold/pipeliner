var Elm = require("./Pipeliner.elm");

var app = Elm.fullscreen(Elm.Pipeliner);
window.define = window.define || ace.define;
var editor = ace.edit("editor");
editor.setTheme("ace/theme/monokai");
editor.getSession().setMode("ace/mode/javascript");
