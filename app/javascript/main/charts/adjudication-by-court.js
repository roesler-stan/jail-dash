import AdjudicationChart from './adjudication.js'

export class AdjudicationByCourtChart extends AdjudicationChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts) {
    const baseUrl = "/api/v1/adjudication_by_court.json?"
    let params = []
    if (opts.fromDate)      { params.push("time_start="+opts.fromDate) }
    if (opts.toDate)        { params.push("time_end="+opts.toDate) }
    if (opts.timeInterval)  { params.push("time_intervals="+opts.timeInterval) }

    const dataUrl = baseUrl + params.join('&');

    opts = Object.assign(opts, { dataUrl: dataUrl })

    this.base_render(targetElementSelector, opts)
  }
}
