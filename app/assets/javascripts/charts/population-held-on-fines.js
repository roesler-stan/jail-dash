class HeldOnFinesChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/population_held_on_fines.json'
    });
    this.base_render(targetElementSelector, opts);
  }
}
