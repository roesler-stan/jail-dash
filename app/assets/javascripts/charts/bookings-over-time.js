class BookingsOverTimeChart extends TimeseriesChart {
  constructor(args) {
    super(args);
    this.args = args;
  }

  render(targetElementSelector) {
    this.base_render(targetElementSelector);
  }
}
