$(document).ready(function () {
  $('.js-accordion-trigger').click(function(e){
    e.preventDefault();
    $(this).parent().toggleClass('is-expanded');

    // only redraw a chart when opening the accordion
    if ($(this).parent().hasClass('is-expanded')) {
      $(this).trigger('drawchart-'+$(this).data('chart'))
    }
  });
});
