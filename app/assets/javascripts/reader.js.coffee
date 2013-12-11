# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_entries = ->
  if $('#entries > .entry.active').length == 0
    entry_active($('#entries > .entry:first'))


start_key_listen = ->
  if $.listening_key == true
    return true

  $.listening_key = true
  $(window).keydown( (e)->
    active_entry = $('#entries > .entry.active')
    active_class = 'active'
    active_offset = 0;

    switch e.keyCode
      when 86
      #v
        os_is_not_windows = navigator.platform.indexOf("Win") == -1
        userAgent = navigator.userAgent.toLowerCase().indexOf('chrome') != -1;
        link = active_entry.find('.entry-title a')
        if (userAgent.indexOf('chrome') != -1) ||  (userAgent.indexOf('safari') != -1
          mouse_event = document.createEvent("MouseEvents")
          mouse_event.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, !os_is_not_windows, false, false, os_is_not_windows, 0, null)
          link[0].dispatchEvent(mouse_event) if link.length > 0
        else
          url = link.attr('href')
          window.open(url)
      when 74
        #j
        if active_entry.length == 0
          active_entry = $('#entries > .entry:first');
        else
          #          active_entry.removeClass(active_class);
          active_entry = active_entry.next();
          entry_active(active_entry);
      when 75
        #k
        if active_entry.length != 0
          if active_entry == $('#entries > .entry:first')
            active_entry = $('#entries > .entry:first')
            active_offset = 0
          else
            #            active_entry.removeClass(active_class);
            active_entry = active_entry.prev();
            entry_active(active_entry);
      when 32, 78
        #space 32
        #n 78
        window.scroll(0,window.scrollY + 50);
      when 80
        #p 80
        window.scroll(0,window.scrollY - 50);

    return true;
  );

entry_active = (elem)->
  unless $(elem).length > 0
     return false
  $('#entries .active').removeClass('active');
  $(elem).addClass('active');
  scrollToEntry(elem);
  unless $(elem).hasClass('readed')
    $(elem).addClass('readed');
    count = parseInt($("#total-count").text())
    if count > 0
      $("#total-count").text( count - 1);
    $.ajax(
      type: 'post',
      url: '/reader/readed/' + $(elem).attr('data-entry-id'),
    );

scrollToEntry = (entry)->
  if $(entry).length > 0
    entries = $('#entries')
    active_entry = $(entry)
    $(document).scrollTop(active_entry.offset().top - entries.offset().top);


$.reader_ready = ->
  unless $("#entries").length > 0
    return true
  show_entries();
  $.autopager(
    content: '.entry'
    appendTo: '#entries'
    start: -> $('#paging-status').css('display':'block');
    load: -> $('#paging-status').css('display':'none');$('time.entry-published').timeago();
  );
  $('.entry-published').timeago();
  start_key_listen();
  $('#entries .entry:not(.active)').on('click', (e)->
    entry_active(this)
  )
  $('#float-topbox .notice').fadeOut(3000);
