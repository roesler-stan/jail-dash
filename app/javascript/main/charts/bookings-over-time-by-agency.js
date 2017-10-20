export class BookingsOverTimeByAgencyChart {
  render(targetElementSelector, opts={}) {
    const baseUrl = "/api/v1/bookings_over_time_by_agency.json?"
    let params = []
    if (opts.fromDate)      { params.push("time_start="+opts.fromDate) }
    if (opts.toDate)        { params.push("time_end="+opts.toDate) }
    if (opts.timeInterval)  { params.push("time_intervals="+opts.timeInterval) }

    const dataUrl = baseUrl + params.join('&');

    const targetElement = d3.select(targetElementSelector);

    // clean up previous render of chart, if present
    targetElement.selectAll('svg').remove()

    const renderedWidth = parseInt(targetElement.style('width'));
    const renderedHeight = opts.height || 500;

    const chart_area_padding = { top: 20, right: 20, bottom: 20, left: 70 };
    const chart_area_margin = { top: 0, right: 200, bottom: 0, left: 0 };

    const chart_area_width = renderedWidth - chart_area_margin.left - chart_area_margin.right;
    const chart_width = chart_area_width - chart_area_padding.left - chart_area_padding.right;
    const legend_width = chart_area_margin.right;
    const height = renderedHeight - chart_area_padding.top - chart_area_padding.bottom;

    const chart_area = targetElement.append('svg')
      .attr('display', 'inline-block')
      .attr('preserveAspectRatio', 'none')
      .attr('height', renderedHeight)
      .attr('width', chart_area_width);
    const legendArea = targetElement.append('svg')
      .attr('display', 'inline-block')
      .attr('preserveAspectRatio', 'none')
      .attr('height', renderedHeight)
      .attr('width', chart_area_margin.right);

    const svgDefs = chart_area.append("defs")

    // those series currently rendered on the chart
    let renderedSeries = [];

    // those series that have been disabled by clicking on the legend
    let inactiveSeries = [];

    let x;

    let colorClasses;

    const y = d3.scaleLinear()
      .range([height, 0]);

    const infotip = d3.tip()
      .attr('class', 'infotip-container')
      .html(function(d, a, b) {
        return "<div class='infotip "+colorClasses(d.name)+"'><div class='tooltip_label'>"+d.period+"</div><div class='tooltip_body'>"+d.name+" Bookings: "+d.booking_count+"</div></div>"
      });

    chart_area.call(infotip);

    d3.json(dataUrl, function(response, agencies) {
      y.domain([
        0,
        d3.max(agencies, function (agency) {
          return d3.max(agency.bookings, function(period) {
            return period.booking_count
          })
        })
      ]).nice();

      const sampleBookings = agencies[0].bookings
      x = d3.scaleOrdinal()
        .domain(sampleBookings.map(function (d) { return d.period }))
        .range(sampleBookings.map(function (d, i, agencies) { return (chart_width/sampleBookings.length)*i }).reverse());

      colorClasses = d3.scaleOrdinal()
        .domain(agencies, function (agency) { return agency.name })
        .range([
          'series-color-1',
          'series-color-2',
          'series-color-3',
          'series-color-4',
          'series-color-5',
          'series-color-6',
          'series-color-7',
          'series-color-8',
          'series-color-9',
          'series-color-10',
          'series-color-11',
          'series-color-12',
        ])

      renderSeriesArray(agencies);

      const axisLayer = chart_area.append("g").attr("transform", "translate(" + chart_area_padding.left + "," + chart_area_padding.top + ")");
      // draw axes first so that they're under all other elements
      axisLayer.append("g")
          .attr("class", "axis")
          .attr("transform", "translate(0,"+height+")")
          .call(xAxis)
      axisLayer.append("g")
          .attr("class", "axis")
          .call(yAxis)
        .append("text")
          .attr("x", 2)
          .attr("y", y(y.ticks().pop()) + 0.5)
          .attr("dy", "0.32em")
          .attr("fill", "#000")

      const legendLayer = legendArea.append("g")
          .attr('class', 'legend_label')
          .attr("text-anchor", "start")
          .attr('cursor', 'pointer')
        .selectAll("g")
        .data(agencies.slice().reverse())
        .enter().append("g")
          .attr("transform", function(d, i) { return "translate(0," + ((i*20) + 20) + ")"; })
          .on('click', function (d, index, elements) {
            // toggle series
            inactiveSeries[d.name] = !inactiveSeries[d.name];

            // swap active/inactive color class on legend
            const this_legend = elements[index];
            d3.select(this_legend)
              .selectAll('circle, text')
              .attr('class',
                function (agency) { return ['legend', legendColorClass(agency.name)].join(' ')
              });

            // re-render all series, excluding those currently inactive
            renderSeriesArray(agencies.filter(function (agency) {
              return !isInactiveSeries(agency.name)
            }));
          });

      legendLayer.append('circle')
        .attr('cx', 20)
        .attr('r', 7);

      legendLayer.append("text")
        .attr("x", 30)
        .attr("y", 0)
        .attr("dy", "0.32em")
        .text(function(agency) { return agency.name; });

      legendLayer.selectAll('circle, text')
        .attr('class', function (agency) { return ['legend', legendColorClass(agency.name)].join(' ') })
    });

    function renderLine(series) {
      const lineLayer = chart_area.append("g")
        .attr('class', colorClasses(series.name))
        .attr("transform", "translate(" + chart_area_padding.left + "," + chart_area_padding.top + ")");

      const line = d3.line()
        .x(function(d) { return x(d.period) })
        .y(function(d) { return y(d.booking_count) });

      lineLayer.selectAll(".dot-halo")
        .data(series.bookings)
        .enter().append("circle")
          .attr("class", function(d, i) { return "dot-halo dot-"+i })
          .attr("cx", line.x())
          .attr("cy", line.y())
          .attr("r", 0)

      lineLayer.append('path')
        .attr('class', 'line')
        .attr('stroke', '#000000')
        .attr('fill', 'none')
        .attr('d', line(series.bookings));

      // draw last, to be on top of all other elements
      // needs to be on top to catch mouse events
      lineLayer.selectAll(".dot")
        .data(series.bookings.map(function(d) { return Object.assign(d, { name: series.name }) }))
        .enter().append("circle")
          .attr("class", "dot")
          .attr("cx", line.x())
          .attr("cy", line.y())
          .attr("r", 7)
          .on('mouseover', function(d, i) {
            lineLayer.select(".dot-halo.dot-"+i).attr("r", 12)
            infotip.show(d, i);
          })
          .on('mouseout', function(d, i) {
            lineLayer.selectAll(".dot-halo").attr("r", 0)
            infotip.hide(d, i);
          });

      renderedSeries.push(lineLayer);
    }

    function renderSeriesArray(seriesArray) {
      // clean up previous render
      renderedSeries.forEach(function (series) {
        series.remove();
      });
      seriesArray.forEach(function (series) {
        renderLine(series);
      });
    }

    function legendColorClass(seriesName) {
      if (isInactiveSeries(seriesName)) {
        return 'hidden';
      } else {
        return colorClasses(seriesName);
      }
    }

    function isInactiveSeries(seriesName) {
      return !!inactiveSeries[seriesName];
    }

    function xAxis(layer) {
      layer.call(
        d3.axisBottom(x)
          .tickSize(0)
      )
      layer.selectAll('.tick')
        .attr('class', 'chart_label')
    }

    function yAxis(layer) {
      layer.call(
        d3.axisRight(y)
          .ticks(null, "s")
          .tickSize(chart_width)
      )
      layer.select('.domain').remove()
      layer.selectAll(".tick:not(:first-of-type) line").attr("stroke", "#D6D6D6");
      layer.selectAll(".tick text")
        .attr('class', 'chart_label')
        .attr("x", -40)
        .attr("dy", 4)
    }
  }
}
