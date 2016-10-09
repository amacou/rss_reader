ready = ->
  $.subscriptions_ready();
$(document).ready(ready);
$(document).on('page:load', ready);
