var SMF = SMF || {};

SMF.ArticlesView = function() {
  this.$el = $('#articles');
  this.template = $('#article_tmpl').html();
};

SMF.ArticlesView.prototype = {
  render: function() {
    var self = this;
    this.$el.html('');

    _(this.articles).each(function(article) {
      var renderedArticle = _.template(self.template, article);
      self.$el.append(renderedArticle);
    });
  }
};
