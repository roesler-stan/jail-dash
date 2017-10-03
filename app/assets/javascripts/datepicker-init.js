$(document).ready(function () {

  $('.datepicker-anchor').each(function () {
    const $el = $(this);

    const start = moment().subtract(29, 'days');
    const end = moment();

    function cb(start, end) {
      $el.find('span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }

    $el.daterangepicker({
      startDate: start,
      endDate: end,
      ranges: {
        'This month': [moment().startOf('month'), moment()],
        'Last month': [moment().subtract(1, 'month'), moment().subtract(1, 'days')],
        'This quarter': [moment().startOf('quarter'), moment()],
        'Last quarter': [moment().subtract(1, 'quarter').startOf('quarter'), moment().subtract(1, 'quarter').startOf('quarter')],
        'This year': [moment().startOf('year'), moment()],
        'Last year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')]
      },
      locale: {
        customRangeLabel: 'Custom...'
      }
    }, cb);

    cb(start, end);
  });

    
});
