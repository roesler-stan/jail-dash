class BookingsByAgencyChart {
  constructor(args) {
    this.args = args;
  }

  render(targetElementSelector) {

    var svg = d3.select(targetElementSelector),
        margin = {top: 20, right: 20, bottom: 20, left: 20},
        width = 700 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom,
        g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var svgDefs = svg.append("defs")

    var purpleGradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-purple')
    var purpleGradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-purple-hover')
    var yellowGradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-yellow')
    var yellowGradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-yellow-hover')
    var gradients = [
      purpleGradient,
      purpleGradientHover,
      yellowGradient,
      yellowGradientHover
    ]

    gradients.forEach(function(gradient) {
      gradient.append('stop')
        .attr('class', 'stop-begin')
        .attr('offset', 0)
      gradient.append('stop')
        .attr('class', 'stop-end')
        .attr('offset', 1)
    })

    // gradientClasses should match those defined in CSS under .column
    var gradientClasses = d3.scaleOrdinal()
        .range(['gradient-purple', 'gradient-yellow']);

    var x0 = d3.scaleBand()
        .rangeRound([0, width])
        .paddingInner(0.1);

    var x1 = d3.scaleBand()
        .padding(0.05);

    var y = d3.scaleLinear()
        .rangeRound([height, 0]);

    var z = d3.scaleOrdinal()
        .range(["#861F41", "#F2B600"]);

    var infotip = d3.tip()
      .attr('class', 'infotip-container')
      .offset([-10, 0])
      .html(function(d) {
        return "<div class='infotip "+d.key+"'><div class='tooltip_label'>"+d.agency+"</div><div class='tooltip_body'>"+d.value+" bookings</div></div>"
      })

    svg.call(infotip);

    d3.json("/bookings_data", function(response, data) {
      var keys = ['yrs_lt5', 'yrs_5_13']

      x0.domain(data.map(function(d) { return d.agency; }));
      x1.domain(keys).rangeRound([0, x0.bandwidth()]);
      y.domain([0, d3.max(data, function(d) { return d3.max(keys, function(key) { return d[key]; }); })]).nice();

      g.append("g")
        .selectAll("g")
        .data(data)
        .enter().append("g")
          .attr("transform", function(d) { return "translate(" + x0(d.agency) + ",0)"; })
        .selectAll("rect")
        .data(function(d) { return keys.map(function(key) { return {agency: d.agency, key: key, value: d[key]}; }); })
        .enter().append("rect")
          .attr("x", function(d) { return x1(d.key); })
          .attr("y", function(d) { return y(d.value); })
          .attr('rx', 3) // border radius
          .attr('ry', 3) // border radius
          .attr("width", x1.bandwidth())
          .attr("height", function(d) { return height - y(d.value); })
          .attr("class", function(d) { return 'column '+gradientClasses(d.key) })
          .on('mouseover', infotip.show)
          .on('mouseout', infotip.hide);

      g.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(0," + height + ")")
        .call(
          d3.axisBottom(x0)
            .tickSize(0)
        );
      g.select('.domain').remove()
      g.selectAll(".tick text")
        .attr('class', 'chart_label')
        .attr("x", 0)
        .attr("dy", 15)

      var legend = g.append("g")
          .attr("font-family", "sans-serif")
          .attr("font-size", 10)
          .attr("text-anchor", "end")
        .selectAll("g")
        .data(keys.slice().reverse())
        .enter().append("g")
          .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

      legend.append("rect")
          .attr("x", width - 16)
          .attr('rx', 3) // border radius
          .attr('ry', 3) // border radius
          .attr("width", 16)
          .attr("height", 16)
          .attr("fill", z);

      legend.append("text")
          .attr("x", width - 24)
          .attr("y", 9.5)
          .attr("dy", "0.32em")
          .text(function(d) { return d; });
    });

  }

}
