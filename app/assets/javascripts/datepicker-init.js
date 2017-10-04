$(document).ready(function () {

  $('.datepicker-anchor').each(function () {
    const $el = $(this);

    const selectedRanges = $el.parent().data('ranges').split(',') // e.g. 'Weekly,Monthly,Quarterly,Yearly'

    const start = moment($el.parent().data('default-time-start'), 'YYYYMMDD')
    const end = moment($el.parent().data('default-time-end'), 'YYYYMMDD')
    const interval = $el.parent().data('default-time-interval')

    const allRanges = {
      'This month': [moment().startOf('month'), moment()],
      'Last month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
      'This quarter': [moment().startOf('quarter'), moment()],
      'Last quarter': [moment().subtract(1, 'quarter').startOf('quarter'), moment().subtract(1, 'quarter').endOf('quarter')],
      'This year': [moment().startOf('year'), moment()],
      'Last year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
      'Weekly': [moment().subtract(9, 'week').startOf('week'), moment().subtract(1, 'week').endOf('week')],
      'Monthly': [moment().subtract(9, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
      'Quarterly': [moment().subtract(9, 'quarter').startOf('quarter'), moment().subtract(1, 'quarter').endOf('quarter')],
      'Yearly': [moment().subtract(9, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
    }

    $el.daterangepicker({
      startDate: start,
      endDate: end,
      ranges: Object.assign( ...selectedRanges.map(function (range) { return { [range]: allRanges[range] } }) ),
      locale: {
        customRangeLabel: 'Custom...'
      },
      alwaysShowCalendars: false, // TODO: this doesn't seem to be working properly?
    }, setDateBanners);

    function setDateBanners(start, end, periodLabel) {
      const specificPeriods = ['Custom...','This month','Last month','This quarter','Last quarter','This year','Last year']

      let text = '';

      if (specificPeriods.includes(periodLabel)) {
        text = periodLabel
        text += ' ('+start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')+')'
      } else { // is an interval like 'Quarterly'
        text = periodLabel
        text += ' (last 8 periods)'
      }

      $el.find('span').html(periodLabel);
      $el.parent().siblings('.chart_subtitle').html(text);
    }

    setDateBanners(start, end, interval);
  });


});
