(function(){
  var Reader = {
    readNextEntry: function() {
      var activeEntry = $('#entries > .entry.active');
      if (activeEntry.length === 0) {
        activeEntry = $('#entries > .entry:first');
      } else {
        activeEntry = activeEntry.next();
      }
      this.entryActive(activeEntry);
    },

    readPrevEntry: function() {
      var activeEntry = $('#entries > .entry.active');
      if (activeEntry.length !== 0) {
        if (activeEntry === $('#entries > .entry:first')) {
          activeEntry = $('#entries > .entry:first');
        } else {
          activeEntry = activeEntry.prev();
        }
      }
      this.entryActive(activeEntry);
    },

    showEntry: function(){
      if ($('#entries > .entry.active').length === 0) {
        this.entryActive($('#entries > .entry:first'));
      }
    },

    entryScrollDown: function(){
      window.scroll(0,window.scrollY + 50);
    },

    entryScrollUp: function() {
      window.scroll(0,window.scrollY - 50);
    },

    startKeyListen: function(){
      if (this.listeningKey === true) {
        return true;
      }

      this.listeningKey = true;
      var reader = this;
      $(window).keydown(function(e) {
        var active_entry = $('#entries > .entry.active');
        var active_offset = 0;

        switch (e.keyCode) {
        case 86:
          //v
          reader.openInBackground();
          break;
        case 74:
          //j
          reader.readNextEntry();
          break;
        case 75:
          //k
          reader.readPrevEntry();
          break;
        case 32:
        case 78:
          //space 32
          //n 78
          reader.entryScrollDown();
          break;
        case 80:
          //p 80
          reader.entryScrollUp();
        }
        return true;
      });
    },

    entryActive: function(entry) {
      if ($(entry).length === 0) {
        return false;
      }

      $('#entries .active').removeClass('active');

      $(entry).addClass('active');
      this.scrollToEntry(entry);

      if (!$(entry).hasClass('readed')) {
        $(entry).addClass('readed');
        var count = parseInt($("#total-count").text());
        if (count > 0) {
          $("#total-count").text( count - 1);
        };

        $.ajax({
          type: 'post',
          url: '/reader/readed/' + $(entry).attr('data-entry-id')
        });
      }
    },

    scrollToEntry: function(entry) {
      if ($(entry).length === 0) {
        return false;
      }

      var entries = $('#entries');
      var activeEntry = $(entry);
      $(document).scrollTop(activeEntry.offset().top - entries.offset().top);
    },

    openInBackground: function() {
      var active_entry = $('#entries > .entry.active');
      var link = active_entry.find('.entry-title a');
      var os_is_windows = (navigator.platform.indexOf("Win") !== -1);
      var userAgent = navigator.userAgent.toLowerCase();
      if (userAgent.indexOf('firefox') !== -1 && link.length > 0) {
        window.open(link[0].href);
        return false;
      }

      var mouse_event = new MouseEvent('click', {
        metaKey: !os_is_windows,
        ctrlKey: os_is_windows
      });

      if (link.length > 0){
        link[0].dispatchEvent(mouse_event);
      }
      return false;
    }
  };

  function ready() {
    if (!$("#entries").length > 0) {
      return true;
    }

    Reader.showEntry();

    $.autopager({
      content: '.entry',
      appendTo: '#entries',
      start: function(){
        $('#paging-status').css({
          'display':'block'
        });
      },
      load: function(){
        $('#paging-status').css({
          'display':'none'
        });
        $('time.entry-published').timeago();
      }
    });

    $('.entry-published').timeago();
    $('#float-topbox .notice').fadeOut(3000);

    Reader.startKeyListen();

    $('#entries .entry:not(.active)').on('click', function(e){
      Reader.entryActive(this);
    });

    $('#next-button').on('click', function(){
      Reader.readNextEntry();
    });

    $('#prev-button').on('click', function(){
      Reader.readPrevEntry();
    });

    $('#scroll-down-button').on('click', function(){
      Reader.entryScrollDown();
    });

    $('#scroll-up-button').on('click', function(){
      Reader.entryScrollUp();
    });

    $('#read-button').on('click', function(){
      Reader.openInBackground();
    });
  };

  $(document).on('page:load', ready);
  ready();
})();
