$(document).ready(function () {
  $('.js-accordion-trigger').click(function(e){
    $(this).find('.submenu').slideToggle('fast');  // apply the toggle to the ul
    $(this).toggleClass('is-expanded');
    e.preventDefault();
  });
});
