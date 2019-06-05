/****************************** search form ******************************/
$(function() {
  $('#searchField').select2({
    ajax: {
      url: URL_PREFIX + 'ajax/search',
      data: function (params) {
        // without this function, Select2 sends two unused arguments to the backend
        return { q: params.term };
      },
      delay: 300,
    },
    minimumInputLength: 1,
    tags: true,
    templateResult: formatResult,
    width: 'resolve',
  });

  function formatResult(data) {
    if (data.html) {
      return $(data.html);
    }

    // fallback to the plain text for optgroups and other messages
    return data.text;
  }

  // redirect before the selection takes place, so that the user doesn't get
  // to see the pill being added to the pillbox
  $('#searchField').on('select2:selecting', function(e) {
    var data = e.params.args.data;
    if (data.url) {
      // existing option
      window.location.href = data.url;
    } else {
      // newly added option (possible because tags = true)
      window.location.href = SEARCH_URL + '/' + data.text;
    }
    return false;
  });

  // intercept the submit button because Select2 doesn't populate the <select>
  // element properly and the search term is not submitted.
  $('#searchForm').submit(function() {
    var value = $('#searchField').find('option').val();
    window.location.href = SEARCH_URL + '/' + value;
    return false;
  });

});

/************ confirmations before discarding pending changes ************/
$(function() {
  var beforeUnloadHandlerAttached = false;

  $('.deleteButton').click(function() {
    var msg = $(this).data('confirm');
    return confirm(msg);
  });

  // ask for confirmation before navigating away from a modified field...
  $('.hasUnloadWarning').on('change input', function() {
    if (!beforeUnloadHandlerAttached) {
      beforeUnloadHandlerAttached = true;
      $(window).on('beforeunload', function() {
        // this is ignored in most browsers
        return 'Are you sure you want to leave?';
      });
    }
  });

  // ...except when actually submitting the form
  $('.hasUnloadWarning').closest('form').submit(function() {
    $(window).unbind('beforeunload');
  });

});

/*************************** vote submissions ***************************/
$(function() {
  $('.voteButton').click(submitVote);

  function submitVote() {
    var btn = $(this);
    $('body').addClass('waiting');
    $.post(URL_PREFIX + 'ajax/save-vote', {
      value: btn.data('value'),
      type: btn.data('type'),
      objectId: btn.data('objectId'),
    }).done(function(newScore) {

      // update the score
      btn.closest('.scoreAndVote').find('.score').text(newScore);

      // enable the opposite button
      btn.siblings('.voted').removeClass('voted');

      // toggle this button
      btn.toggleClass('voted');

    }).fail(function(errorMsg) {
      if (errorMsg.responseJSON) {
        alert(errorMsg.responseJSON);
      }
    }).always(function() {
      $('body').removeClass('waiting');
    });
  }

});

/******************* changing the reputation manually *******************/
$(function() {

  $('#repChange').submit(changeReputation);

  function changeReputation(evt) {
    evt.preventDefault();

    var rep = $(this).find('input').val();
    $.post(URL_PREFIX + 'ajax/change-reputation', {
      value: rep,
    }).done(function(newRep) {

      // update the reputation badge
      $('#repBadge').text(newRep);

      // close the user dropdown
      $('#navbarUserDropdown').dropdown('toggle');

    }).fail(function(errorMsg) {
      if (errorMsg.responseJSON) {
        alert(errorMsg.responseJSON);
      }
    });

    return false;
  }

});
