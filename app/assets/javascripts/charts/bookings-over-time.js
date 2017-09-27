class BookingsOverTimeChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/bookings_over_time.json'
    });
    this.base_render(targetElementSelector, opts);
  }
}
