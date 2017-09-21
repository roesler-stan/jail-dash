class AdjudicationChart {
  base_render(targetElementSelector, opts) {
    this.opts = opts;

    const color = opts.color || 'yellow';

    var svg = d3.select(targetElementSelector),
        margin = {top: 20, right: 20, bottom: 20, left: 70},
        width = 700 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom,
        g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var svgDefs = svg.append("defs")

    var gradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-'+color)
        .attr('x1', '50%')
        .attr('y1', '0%')
        .attr('x2', '50%')
        .attr('y2', '100%')
    var gradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-'+color+'-hover')
        .attr('x1', '50%')
        .attr('y1', '0%')
        .attr('x2', '50%')
        .attr('y2', '100%')
    var gradients = [
      gradient,
      gradientHover
    ]

    gradients.forEach(function(gradient) {
      gradient.append('stop')
        .attr('class', 'stop-begin')
        .attr('offset', 0)
      gradient.append('stop')
        .attr('class', 'stop-end')
        .attr('offset', 1)
    })

    var y = d3.scaleBand()
        .rangeRound([0, height])
        .paddingInner(0.2);

    var x = d3.scaleLinear()
        .rangeRound([0, width]);

    var infotip = d3.tip()
      .attr('class', 'infotip-container')
      .offset([-10, 0])
      .html(function(d) {
        return "<div class='infotip "+color+"'><div class='tooltip_label'>"+d.agency+"</div><div class='tooltip_body'>"+d.value+" bookings</div></div>"
      })

    svg.call(infotip);

    d3.json("/adjudication_data", function(response, data) {
      y.domain(data.map(function(d) { return d.agency }));
      x.domain([0, d3.max(data, function(d) { return d.value })]).nice();

      g.append("g")
        .selectAll("g")
        .data(data)
        .enter().append("g")
        .selectAll("rect")
        .data(function(d) { return [d] })
        .enter().append("rect")
          .attr("x", 0)
          .attr("y", function(d) { return y(d.agency); })
          .attr('rx', 3) // border radius
          .attr('ry', 3) // border radius
          .attr("height", y.bandwidth())
          .attr("width", function(d) { return x(d.value); })
          .attr("class", 'row gradient-'+color)
          .on('mouseover', infotip.show)
          .on('mouseout', infotip.hide);

      g.append("g")
          .attr("class", "axis")
          .call(d3.axisLeft(y)
            .ticks(null, "s")
            .tickSize(0)
            .tickPadding(20)
          )
        .append("text")
          .attr("y", 2)
          .attr("x", x(x.ticks().pop()) + 0.5)
          .attr("dy", "0.32em")
          .attr("fill", "#000")
    });
  }
}
