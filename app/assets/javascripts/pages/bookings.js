$(document).ready(function () {

  if ($('body').hasClass('bookings')) {
    initialPageRender();
  }

  $('.datepicker-anchor').on('apply.daterangepicker', function (ev, picker) {
    const chartName = $(ev.target).parent().data('chartname')
    if (chartName === 'bookings-by-agency') {
      renderBookingsByAgency(picker);
    } else if (chartName === 'bookings-over-time') {
      renderBookingsOverTime(picker);
    } else if (chartName === 'bookings-over-time-by-agency') {
      renderBookingsOverTimeByAgency(picker);
    }
  });

});

function initialPageRender() {

  renderBookingsByAgency();

  renderBookingsOverTime();

  renderBookingsOverTimeByAgency();
}

function renderBookingsByAgency(pickerArgs) {
  const chartSelector = ".chart[data-chartname='bookings-by-agency']"
  const $chartNode = $(chartSelector)

  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  const opts = setOptions($chartNode, pickerArgs);
  new BookingsByAgencyChart().render(chartSelector, opts);
}

function renderBookingsOverTime(pickerArgs) {
  const chartSelector = ".chart[data-chartname='bookings-over-time']";
  const $chartNode = $(chartSelector);

  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  const opts = setOptions($chartNode, pickerArgs);
  new BookingsOverTimeChart().render(chartSelector, opts)
}

function renderBookingsOverTimeByAgency(pickerArgs) {
  const chartSelector = ".chart[data-chartname='bookings-over-time-by-agency']";
  const $chartNode = $(chartSelector);

  const opts = setOptions($chartNode, pickerArgs);

  new BookingsOverTimeByAgencyChart().render(chartSelector, opts)
}

function setOptions($chartNode, pickerArgs) {
  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  let opts = {}
  if (pickerArgs) {
    opts.fromDate = pickerArgs.startDate.format('YYYYMMDD')
    opts.toDate = pickerArgs.endDate.format('YYYYMMDD')
    opts.timeInterval = pickerArgs.chosenLabel
  } else {
    opts.fromDate = defaultStart
    opts.toDate = defaultEnd
    opts.timeInterval = defaultTimeInterval
  }

  return opts;
}
