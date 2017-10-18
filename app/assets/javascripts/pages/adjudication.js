$(document).ready(function () {

  if ($('body').hasClass('adjudication')) {
    initialAdjudicationPageRender();
  }

  $('.datepicker-anchor').on('apply.daterangepicker', function (ev, picker) {
    const chartName = $(ev.target).parent().data('chartname');
    if (chartName === 'adjudication-by-court') {
      adjudicationByCourt(picker);
    } else if (chartName === 'adjudication-by-judge') {
      adjudicationByJudge(picker);
    }
  });

  $courtsSelector = $('.courts-selector')
  $courtsSelector.click(function () {
    $courtsSelector.find('.options').show();
  });
  $courtsSelector.find('.option').click(function (e) {
    $courtsSelector.find('.dropdown_selection').text(e.target.textContent);
    $courtsSelector.find('.dropdown_selection').data('courtname', $(e.target).data('courtname'));
    $courtsSelector.siblings('.datepicker-anchor').trigger('apply.daterangepicker');
    $courtsSelector.find('.options').hide();
    e.stopPropagation()
  });

});

function initialAdjudicationPageRender() {

  adjudicationByCourt();

  adjudicationByJudge();

}

function adjudicationByCourt(pickerArgs) {
  const chartSelector = ".chart[data-chartname='adjudication-by-court']"
  const $chartNode = $(chartSelector)

  const opts = setOptions($chartNode, pickerArgs);
  new AdjudicationByCourtChart().render(chartSelector, Object.assign(opts, { color: 'purple' }));
}

function adjudicationByJudge(pickerArgs) {
  const chartSelector = ".chart[data-chartname='adjudication-by-judge']"
  const $chartNode = $(chartSelector)

  const opts = setOptions($chartNode, pickerArgs);
  new AdjudicationByJudgeChart().render(chartSelector, Object.assign(opts, { color: 'yellow' }));
}

function setOptions($chartNode, pickerArgs) {
  const defaultStart = $chartNode.data('default-time-start')
  const defaultEnd = $chartNode.data('default-time-end')
  const defaultTimeInterval = $chartNode.data('default-time-interval')

  const courts = $chartNode.find('.courts-selector .dropdown_selection').data('courtname');

  let opts = {}
  if (courts) {
    opts.courts = courts
  }
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
