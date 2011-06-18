var SoManyFeeds = ( function() {

  var defaultSources  = initSoManyFeeds[0],
      selectedSources = initSoManyFeeds[1],
      links = $('a.source');

  var sourcesFromUrl = function(url) {
    url = url.split('/')
    return url[url.length - 1].split('+');
  };

  var urlFromSources = function(sources) {

    var url = '/';
    sources = sources.sort();

    if (sources.length > 0 && sources.toString() != defaultSources.toString())
      $.each(sources, function(i, src){ url += src + '+'; } );

    return url.replace(/\+$/g, '');

  }; // urlFromSources

  var updateRss = function() {

    var url = urlFromSources(selectedSources);

    if ( url.indexOf('+') < 0 )
      url += 'index.rss';
    else
      url += '.rss';

    $("head link[type='application/rss+xml']").attr('href', url);

  }; // updateRss

  var updateLink = function() {

    var link = $(this);
    var newSources = selectedSources.slice();
    var source = link.attr('data-source')

    if (( link.hasClass('selected') && selectedSources.indexOf(source) < 0 ) ||
    ( !link.hasClass('selected') && selectedSources.indexOf(source) >= 0))
      link.toggleClass('selected');

    if ( link.hasClass('selected') )
      newSources.splice( selectedSources.indexOf(source), 1 );

    else
      newSources.push( source );

    link.attr('href', urlFromSources(newSources));

  }; // updateLink

  var ajaxifyLink = function() {

    var link = $(this);
    var source = link.attr('data-source');

    $('#loading').show();

    if ( link.hasClass('selected') && selectedSources.length > 1 ) {
      selectedSources.splice( selectedSources.indexOf(source), 1 );
      $('article.'+source.toLowerCase()).hide();

      updatePage(true);
    }

    else if ( !link.hasClass('selected') && $('article.'+source.toLowerCase()).length > 0 ) {
      selectedSources.push( source );
      $('article.'+source.toLowerCase()).show();

      updatePage(true);
    }

    else {
      var url = link.attr('href');

      if ( url.indexOf('+') )
        url += '.xhr';
      else
        url += 'index.xhr';

      $.ajax({
        url: url,
        context: link,
        success: function(data){
          $('section.main').html(data);
          updatePage(true);
        }
      });
    }

    return false;

  }; // ajaxifyLink

  window.onpopstate = function(event) {
    if (event.state) {

      selectedSources = sourcesFromUrl(document.location.href);
      if (selectedSources.length == 0)
        selectedSources = defaultSources.slice();

      $('#loading').show();
      $('section.main').load( urlFromSources(selectedSources) + '.xhr' );
      updatePage(false);

    }
  };

  var updatePage = function(pushHistory) {

    $('a.source').each( updateLink );
    updateRss();
    $('#loading').hide();

    if (pushHistory)
      try {
        history.pushState({}, '', urlFromSources(selectedSources).replace(/(index)?\.xhr$/, ''));
      } catch(e) {}

  };

  links.click( ajaxifyLink );

  return {

    updateSources: function(sources) {
      selectedSources = sources;
    }

  }

}() );
