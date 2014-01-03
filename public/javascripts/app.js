(function($, window, document) {
  $(function() {
    $('#new_order').submit(function(e) {
      e.preventDefault();
      var form = $(this);
      $.post(form.attr('action'), form.serialize(), function(res) {
        console.log(res);
      });
    });
  });
}(window.jQuery, window, document));