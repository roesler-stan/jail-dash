import TimeseriesChart from './timeseries.js';

export class BookingsOverTimeChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    const base_url = "/api/v1/bookings_over_time.json?"
    let params = []
    if (opts.fromDate)      { params.push("time_start="+opts.fromDate) }
    if (opts.toDate)        { params.push("time_end="+opts.toDate) }
    if (opts.timeInterval)  { params.push("time_intervals="+opts.timeInterval) }
    const dataUrl = base_url + params.join('&');

    opts = Object.assign(opts, {
      dataUrl: dataUrl,
      color: 'purple',
    });
    this.base_render(targetElementSelector, opts);
  }
}
