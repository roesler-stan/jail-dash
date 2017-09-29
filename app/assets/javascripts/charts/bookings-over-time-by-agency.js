class BookingsOverTimeByAgencyChart {
  render(targetElementSelector, opts={}) {
    opts = Object.assign(opts, {
      data_url: '/bookings_over_time_by_agency.json'
    });
    this.opts = {
      renderedHeight: opts.height || 500,
      data_url: opts.data_url,
    }

    const targetElement = d3.select(targetElementSelector);

    // clean up previous render of chart, if present
    targetElement.selectAll('svg').remove()

    const renderedWidth = parseInt(targetElement.style('width'));

    const margin = { top: 20, right: 20, bottom: 20, left: 70 };

    const width = renderedWidth - margin.left - margin.right;
    const height = this.opts.renderedHeight - margin.top - margin.bottom;

    const svg = targetElement.append('svg')
      .attr('preserveAspectRatio', 'none')
      .attr('height', this.opts.renderedHeight)
      .attr('width', renderedWidth);

    const svgDefs = svg.append("defs")

    let x;

    const y = d3.scaleLinear()
      .range([height, 0]);

    const infotip = d3.tip()
      .attr('class', 'infotip-container')
      .html(function(d) {
        return "<div class='infotip purple'><div class='tooltip_label'>"+d.period+"</div><div class='tooltip_body'>Total bookings: "+d.booking_count+"</div></div>"
      });

    svg.call(infotip);

    d3.json(this.opts.data_url, function(response, agencies) {
      y.domain([
        0,
        d3.max(agencies, function (agency) {
          return d3.max(agency.bookings, function(period) {
            return period.booking_count
          });
        });
      ]).nice();

      const sampleBookings = agencies[0].bookings
      x = d3.scaleOrdinal()
        .domain(sampleBookings.map(function (d) { return d.period }))
        .range(sampleBookings.map(function (d, i, agencies) { return (width/sampleBookings.length)*i }).reverse());

      agencies.forEach(function (agency) {
        renderLine(agency)
      });

      const axisLayer = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
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
    });

    function renderLine(series) {
      const lineLayer = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

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
        .data(series.bookings)
        .enter().append("circle")
          .attr("class", "dot")
          .attr("cx", line.x())
          .attr("cy", line.y())
          .attr("r", 7)
          .on('mouseover', function(d, i) {
            lineLayer.select(".dot-halo.dot-"+i).attr("r", 12)
            infotip.show(d, i)
          })
          .on('mouseout', function(d, i) {
            lineLayer.selectAll(".dot-halo").attr("r", 0)
            infotip.hide(d, i);
          });
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
          .tickSize(width)
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
