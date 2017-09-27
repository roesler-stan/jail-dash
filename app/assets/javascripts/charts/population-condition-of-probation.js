class ConditionOfProbationChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/population_condition_of_probation.json'
    });
    this.base_render(targetElementSelector, opts);
  }
}
