import {ConditionOfProbationChart} from '../charts/population-condition-of-probation.js'
import {JusticeCourtCommitmentsChart} from '../charts/population-justice-court-commitments.js'
import {HeldOnFinesChart} from '../charts/population-held-on-fines.js'

$(document).ready(function () {
  if ($('body').hasClass('population')) {
    setup();
  }
});

function setup () {
  $('.js-accordion-trigger').click(function(e){
    e.preventDefault();
    $(this).parent().parent().toggleClass('is-expanded');

    // only redraw a chart when opening the accordion
    if ($(this).parent().parent().hasClass('is-expanded')) {
      $(this).trigger('drawchart-'+$(this).data('chart'))
    }
  });

  $(document).on('drawchart-condition-of-probation', function () {
    renderConditionOfProbation();
  });
  $(document).on('drawchart-justice-court-commitments', function () {
    renderJusticeCourtCommitments();
  });
  $(document).on('drawchart-held-on-fines', function () {
    renderHeldOnFines();
  });
}

function renderConditionOfProbation() {
  const chartSelector = "#condition-of-probation";

  const opts = {
    height: 300,
  }
  new ConditionOfProbationChart().render(chartSelector, opts);
}

function renderJusticeCourtCommitments() {
  const chartSelector = "#justice-court-commitments";

  const opts = {
    height: 300,
  }
  new JusticeCourtCommitmentsChart().render(chartSelector, opts);
}

function renderHeldOnFines() {
  const chartSelector = "#held-on-fines";

  const opts = {
    height: 300,
  }
  new HeldOnFinesChart().render(chartSelector, opts);
}
