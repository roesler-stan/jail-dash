$(document).ready(function () {

  if ($('body').hasClass('adjudication')) {
    initialPageRender();
  }

  $('.datepicker-anchor').on('apply.daterangepicker', function (ev, picker) {
    const chartName = $(ev.target).parent().data('chartname')
    if (chartName === 'adjudication-by-court') {
      adjudicationByCourt(picker);
    } else if (chartName === 'adjudication-by-judge') {
      adjudicationByJudge(picker);
    }
  });

});

function initialPageRender() {

  adjudicationByCourt();

  adjudicationByJudge();

}

function adjudicationByCourt(pickerArgs) {
  const chartSelector = ".chart[data-chartname='adjudication-by-court']"
  const $chartNode = $(chartSelector)

  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  const opts = setOptions($chartNode, pickerArgs);
  new AdjudicationByCourtChart().render(
    chartSelector,
    Object.assign(opts, { color: 'purple' }),
  );
}

function adjudicationByJudge(pickerArgs) {
  const chartSelector = ".chart[data-chartname='adjudication-by-judge']"
  const $chartNode = $(chartSelector)

  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  const opts = setOptions($chartNode, pickerArgs);
  new AdjudicationByJudgeChart().render(
    chartSelector,
    Object.assign(opts, { color: 'yellow' }),
  );
}

function setOptions($chartNode, pickerArgs) {
  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  let opts = {}
  if (pickerArgs) {
    opts.fromDate = pickerArgs.startDate.format('YYYYMMDD')
    opts.toDate = pickerArgs.endDate.format('YYYYMMDD')
    opts.timeInterval = pickerArgs.chosenLabel
  } else {
    opts.fromDate = defaultStart
    opts.toDate = defaultEnd
    opts.timeInterval = defaultTimeInterval
  }

  return opts;
}
