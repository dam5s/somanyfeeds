$(function() {
  new SMF.ColumnsResizer().setup();
  window.router = new SMF.Router(window.initialSlugs);
});
