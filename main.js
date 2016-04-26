var Elm = require("./Pipeliner.elm");

var app = Elm.fullscreen(Elm.Pipeliner, { currentCode: ["", []] });

window.define = window.define || ace.define;
var editor = ace.edit("editor");
editor.session.on('changeMode', function(e, session){
  if ("ace/mode/javascript" === session.getMode().$id) {
    if (!!session.$worker) {
      session.$worker.send("changeOptions", [{
        "undef": true
      }]);
    }
  }
});
editor.setTheme("ace/theme/monokai")
editor.getSession().setMode("ace/mode/javascript");

document.getElementById("commit").addEventListener("click", function () {
  var currentCode = editor.getValue();
  if (currentCode.trim()) {
    var annotations = editor.getSession().getAnnotations();
    annotations = annotations.filter(function (annotation) {
      return annotation.type === "error" || annotation.type === "warning";
    }).map(function(annotation) {
      annotation.errorType = annotation.type;
      delete annotation.type;
      return annotation;
    });
    app.ports.currentCode.send([currentCode, annotations]);
  }
}, false);

$(document).ready(function(){
    $('.menu .item').tab();
});
