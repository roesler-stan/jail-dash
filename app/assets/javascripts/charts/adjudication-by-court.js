class AdjudicationByCourtChart extends AdjudicationChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts) {
    opts = Object.assign(opts, {
      dataUrl: '/api/v1/adjudication_by_court.json'
    })
    this.base_render(targetElementSelector, opts)
  }
}
