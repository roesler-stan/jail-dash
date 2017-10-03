class JusticeCourtCommitmentsChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/api/v1/population_justice_court_commitments.json',
      percentage_mode: true,
    });
    this.base_render(targetElementSelector, opts);
  }
}
