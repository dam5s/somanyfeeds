var SMF = SMF || {};

SMF.ColumnsResizer = function() {
  this.$sectionCols = $('section.main');
  this.$mainHeader = $('header.main');
};

SMF.ColumnsResizer.prototype = {
  setup: function() {
    var self = this;

    $(window).resize(function() {
      self.resizeCols();
    });

    this.resizeCols();
  },

  resizeCols: function() {
    var windowHeight = $(window).height();

    this.$sectionCols.css('height', windowHeight+'px');
    this.$mainHeader.css('height', windowHeight+'px');
  }
};

