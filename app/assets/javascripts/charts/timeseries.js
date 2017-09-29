class TimeseriesChart {
  base_render(targetElementSelector, opts={}) {
    this.opts = {
      renderedHeight: opts.height || 500,
      data_url: opts.data_url,
      color: opts.color || 'purple',
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

    const g = svg.append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
      .attr('class', this.opts.color);

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

    d3.json(this.opts.data_url, function(response, data) {
      y.domain([0, d3.max(data, function(d) { return d.booking_count })]).nice();

      x = d3.scaleOrdinal()
        .domain(data.map(function (d) { return d.period }))
        .range(data.map(function (d, i, data) { return (width/data.length)*i }).reverse());

      const line = d3.line()
        .x(function(d) { return x(d.period) })
        .y(function(d) { return y(d.booking_count) });

      // draw axes first so that they're under all other elements
      g.append("g")
          .attr("class", "axis")
          .attr("transform", "translate(0,"+height+")")
          .call(xAxis)
      g.append("g")
          .attr("class", "axis")
          .call(yAxis)
        .append("text")
          .attr("x", 2)
          .attr("y", y(y.ticks().pop()) + 0.5)
          .attr("dy", "0.32em")
          .attr("fill", "#000")

      g.selectAll(".dot-halo")
        .data(data)
        .enter().append("circle")
          .attr("class", function(d, i) { return "dot-halo dot-"+i })
          .attr("cx", line.x())
          .attr("cy", line.y())
          .attr("r", 0)

      g.append('path')
        .attr('class', 'line')
        .attr('fill', 'none')
        .attr('d', line(data));

      // draw last, to be on top of all other elements
      // needs to be on top to catch mouse events
      g.selectAll(".dot")
        .data(data)
        .enter().append("circle")
          .attr("class", "dot")
          .attr("cx", line.x())
          .attr("cy", line.y())
          .attr("r", 7)
          .on('mouseover', function(d, i) {
            g.select(".dot-halo.dot-"+i).attr("r", 12)
            infotip.show(d, i)
          })
          .on('mouseout', function(d, i) {
            g.selectAll(".dot-halo").attr("r", 0)
            infotip.hide(d, i);
          });
    });

    function xAxis(g) {
      g.call(
        d3.axisBottom(x)
          .tickSize(0)
      )
      g.selectAll('.tick')
        .attr('class', 'chart_label')
    }

    function yAxis(g) {
      g.call(
        d3.axisRight(y)
          .ticks(null, "s")
          .tickSize(width)
      )
      g.select('.domain').remove()
      g.selectAll(".tick:not(:first-of-type) line").attr("stroke", "#D6D6D6");
      g.selectAll(".tick text")
        .attr('class', 'chart_label')
        .attr("x", -40)
        .attr("dy", 4)
    }
  }
}
