$ ->
  socket = new WebSocket "ws://#{window.location.host}/users/connect"

  socket.onmessage = (event) ->
    if event.data.length
      $("#received").append "#{event.data}<br>"

  $("body").on "submit", "form.chat", (event) ->
    event.preventDefault()
    $input = $(this).find("input")
    socket.send $input.val()
    $input.val(null)
