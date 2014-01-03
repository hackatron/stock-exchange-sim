window.onload = function() {
  (function() {
    var show = function(el) {
      return function(msg) { el.innerHTML = msg + '<br />' + el.innerHTML; }
    }(document.getElementById('msgs'));

    var ws       = new WebSocket('ws://' + window.location.hostname + ':1234');
    ws.onopen    = function()  { show('websocket opened'); };
    ws.onclose   = function()  { show('websocket closed'); }
    ws.onmessage = function(m) { show('websocket message: ' +  m.data); };
  })();
}