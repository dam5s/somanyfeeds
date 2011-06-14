TrySMF = ( function() {

  var instance;

  function TrySMF() {

    instance = this;

    // Step 2
    this.selectedForm = null;
    $('.step-2 #feed-types a').click( this.showFeedForm );
    $('.step-2 section.feed button').click( this.hideFeedForm );
    $('.step-2 .button').click( this.submitFeedForm );

    // Step 3
    if ( $('.step-3').size() > 0 ) {
      $.template( "article", '<article class="${source}"><header><h1><a href="${link}">${title}</a></h1><h2>Source: ${feed_name}<time datetime="${datetime}" pubdate>${display_date}</time></h2></header><section>{{html content}}</section></article>' );

      this.loadedArticles = [];
      this.loadArticles();
    }

  };

  TrySMF.prototype.showFeedForm = function() {
    var type = $(this).parent().attr('class');
    var section = $('section.feed.'+type)

    section.show();
    $('.step-2 input.button').show();
    $('#feed-types').hide();

    instance.selectedForm = section.find('form');
    return false;
  };

  TrySMF.prototype.hideFeedForm = function() {
    $('#feed-types').show();
    $(this).parent().hide();
    $('.step-2 input.button').hide();

    instance.selectedForm = null;
  };

  TrySMF.prototype.submitFeedForm = function() {
    instance.selectedForm.submit();
  };

  TrySMF.prototype.loadArticles = function() {

    $.get('/try-it/step-3.json', function(data) {

      $.each( data, function() {

        if ( $.inArray( this.id, instance.loadedArticles ) < 0 ) {
          instance.loadedArticles.push( this.id );

          $.tmpl( "article", this ).appendTo( $('#articles') );
          $('#articles article').last().fadeIn( 700 );
        }

      });

    });

    setTimeout( this.loadArticles, 3000 );
  };

  return TrySMF;

} )();

new TrySMF();
