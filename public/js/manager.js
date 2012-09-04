var Manager = (function() {

  // BEGIN -- Automatically downsize columns to the size of the window
  var $colsContainer = $('section.main'),
      $sectionCols = $colsContainer.find('> section'),
      $formCols = $colsContainer.find('> form'),
      $mainHeader = $('header.main'),
      resizeCols = function() {
        var windowHeight = $(window).height();

        $sectionCols.css('height', windowHeight+'px');
        $formCols.css('height', windowHeight+'px');
        $mainHeader.css('height', windowHeight+'px');
      };
  $(window).resize(resizeCols);
  $(resizeCols);
  // END -- Automatically downsize columns to the size of the window

  // BEGIN -- Setup chosen
  $('select').chosen();
  // END -- Setup chosen

  // BEGIN -- Feeds list
  $('dl.feed > dt', '#my-feeds').click(function() {
    var $dd = $(this).closest('dl').find('>dd');

    if ($dd.hasClass('expanded')) { $dd.removeClass('expanded'); }
    else { setTimeout(function() {$dd.addClass('expanded')}, 400); }

    $dd.slideToggle();
  });
  // END -- Feeds list

  return {};
}());
