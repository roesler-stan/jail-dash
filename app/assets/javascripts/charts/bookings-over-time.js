class BookingsOverTimeChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/api/v1/bookings_over_time.json?time_unit=custom&time_start=20110101&time_end=20150601',
      color: 'purple',
    });
    this.base_render(targetElementSelector, opts);
  }
}
