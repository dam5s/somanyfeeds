var Manager = ( function() {

    var updateFeed = function() {
        var form = $(this).closest('form')

        $.ajax({
            url: form.attr('action'),
            data: form.serialize(),
            type: form.attr('method'),
            context: this,
            success: function(data) {
                if ( data.match(/<section/) ) {
                    var section = $(this).closest('section');
                    section.before(data);
                    section.prev().find('form.update input').change(updateFeed);
                    section.remove();
                }
            }
        });
    };

    var deleteFeed = function() {
        return confirm('Are you sure you want to delete this feed?');
    };

    var displayFeedTypes = function() {
        $('ul#feed-types')
            .last()
            .fadeTo(0, 0)
            .show()
            .animate({left: 0, opacity: 1}, 500);

        $(this).hide();

        return false;
    }

    var displayNewFeed = function() {

        $.ajax({
            url: $(this).attr('href'),
            context: $(this),
            success: function(data) {
                $('#add-feed').before(data);

                var new_feed = $('section.feed.new').last();

                $('#feed-types').hide();

                $('#add-feed')
                    .show()
                    .animate({left: '-50%', opacity: 0}, 0)
                    .animate({left: 0, opacity: 1}, 500);

                new_feed
                    .fadeTo(0, 0)
                    .show()
                    .animate({left: 0, opacity: 1}, 500);
                new_feed
                    .find('form.update input')
                    .change(updateFeed);
                new_feed
                    .find('form.delete input')
                    .last()
                    .click(deleteNewFeed);

            }
        });

        return false;

    };

    var deleteNewFeed = function() {
        var section = $(this).closest('section');

        section
            .nextAll()
            .animate({left: '+50%', opacity: 0}, 0)
            .animate({left: 0, opacity: 1}, 500);

        section
            .animate({left: 0, opacity: 0}, 500);

        if ( $('section.feed.new').length > 1 )
            section
                .animate({left: 0, opacity: 0}, 500)
                .detach();
        else
            section
                .animate({left: 0, opacity: 0}, 500);

        return false;
    };

    $('#flash').delay(5000).fadeOut();

    $('section.feed form.update input').change( updateFeed );
    $('section.feed.existing form.delete input').click( deleteFeed );
    $('section.feed.new form.delete input').click( deleteNewFeed );

    $('#add-feed').click( displayFeedTypes );
    $('#feed-types a').click( displayNewFeed );

    return {
      flash: function(type, flash, feed_id) {
        $('#'+feed_id).fadeOut().fadeIn();
      }
    };

}() );
