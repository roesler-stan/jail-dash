class AdjudicationByJudgeChart extends AdjudicationChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts) {
    opts = Object.assign(opts, {
      data_url: '/adjudication_by_judge.json'
    })
    this.base_render(targetElementSelector, opts)
  }
}
