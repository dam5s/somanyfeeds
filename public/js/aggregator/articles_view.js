var SMF = SMF || {};

SMF.ArticlesView = function() {
  this.$el = $('#articles');
  this.template = $('#article_tmpl').html();
  this.masonry = new Masonry(document.querySelector("#articles"), {itemSelecotr: "article"});
  this.articleElements = null;
};

SMF.ArticlesView.prototype = {
  render: function() {
    var self = this;

    var $articles = $("article", self.$el);
    if ($articles.length > 0) {
      this.masonry.remove($articles);
      $articles.remove();
    }

    _(this.articles).each(function(article) {
      var renderedArticle = _.template(self.template, article);
      self.$el.append(renderedArticle);
    });

    var $articles = $("article", self.$el);

    this.$el.imagesLoaded(function() {
      setTimeout(function() {
        self.masonry.appended($articles);
        self.masonry.layout();
      }, 800);
    });
  }
};
