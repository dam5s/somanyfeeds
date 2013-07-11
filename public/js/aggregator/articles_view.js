var SMF = SMF || {};

SMF.ArticlesView = function() {
  this.$el = $('#articles');
  this.template = $('#article_tmpl').html();
};

SMF.ArticlesView.prototype = {
  render: function() {
    var self = this;
    $("article", this.$el).css("opacity", "1");
    try { this.$el.masonry('destroy'); } catch(e) {}
    this.$el.html('');

    var articleElements = _(this.articles).map(function(article) {
      var renderedArticle = _.template(self.template, article);
      self.$el.append(renderedArticle);
    });

    setTimeout(function() {
      self.$el.masonry({itemSelector: 'article'});
      $("article", self.$el).css("opacity", "1");
    }, 500);
  }
};
