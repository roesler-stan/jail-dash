class BookingsByAgencyChart {
  constructor(args) {
    this.args = args;
  }

  render(targetElementSelector) {
    const targetElement = d3.select(targetElementSelector);

    // clean up previous render of chart, if present
    targetElement.selectAll('svg').remove()

    const renderedHeight = 500;
    const renderedWidth = parseInt(targetElement.style('width'));

    const margin = { top: 20, right: 20, bottom: 20, left: 70 };

    const width = renderedWidth - margin.left - margin.right;
    const height = renderedHeight - margin.top - margin.bottom;

    const svg = targetElement.append('svg')
      .attr('preserveAspectRatio', 'none')
      .attr('height', renderedHeight)
      .attr('width', renderedWidth);

    const g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    const svgDefs = svg.append("defs")

    const purpleGradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-purple')
    const purpleGradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-purple-hover')
    const yellowGradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-yellow')
    const yellowGradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-yellow-hover')
    const gradients = [
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
    const gradientClasses = d3.scaleOrdinal()
        .range(['gradient-purple', 'gradient-yellow']);

    const x0 = d3.scaleBand()
        .rangeRound([0, width])
        .paddingInner(0.1);

    const x1 = d3.scaleBand()
        .padding(0.05);

    const y = d3.scaleLinear()
        .rangeRound([height, 0]);

    const z = d3.scaleOrdinal()
        .range(['purple', 'yellow']);

    const infotip = d3.tip()
      .attr('class', 'infotip-container')
      .offset([-10, 0])
      .html(function(d) {
        let tooltip = "<div class='infotip "+z(d.key)+"'><div class='tooltip_label'>"+d.agency+"</div><div class='tooltip_body'>"
        if (d.key == 'booking') {
          tooltip += ( d.percent+"% ("+d.count+" bookings)" )
        } else if (d.key == 'pop') {
          tooltip += ( d.percent+"% of population" )
        }
        tooltip += "</div></div>"
        return tooltip
      })

    svg.call(infotip);

    d3.json("/api/v1/bookings_by_agency.json", function(response, data) {
      var keys = ['booking', 'pop']

      x0.domain(data.agencies.map(function(d) { return d.name; }));
      x1.domain(keys).rangeRound([0, x0.bandwidth()]);
      y.domain([0, d3.max(data.agencies, function(d) { return d3.max(keys, function(key) { return d[key+'_pct']; }); })]).nice();

      g.append("g")
        .selectAll("g")
        .data(data.agencies)
        .enter().append("g")
          .attr("transform", function(d) { return "translate(" + x0(d.name) + ",0)"; })
        .selectAll("rect")
        .data(function(d) { return keys.map(function(key) { return {agency: d.name, key: key, count: d[key+'_count'], percent: d[key+'_pct']}; }); })
        .enter().append("rect")
          .attr("x", function(d) { return x1(d.key); })
          .attr("y", function(d) { return y(d.percent); })
          .attr('rx', 3) // border radius
          .attr('ry', 3) // border radius
          .attr("width", x1.bandwidth())
          .attr("height", function(d) { return height - y(d.percent); })
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

      const legend = g.append("g")
          .attr("font-family", "sans-serif")
          .attr("font-size", 10)
          .attr("text-anchor", "end")
        .selectAll("g")
        .data(keys)
        .enter().append("g")
          .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

      legend.append("rect")
          .attr("x", width - 16)
          .attr('rx', 3) // border radius
          .attr('ry', 3) // border radius
          .attr("width", 16)
          .attr("height", 16)
          .attr('class', z);

      legend.append("text")
          .attr("x", width - 24)
          .attr("y", 9.5)
          .attr("dy", "0.32em")
          .text(function(d) { return '% of total '+d; });
    });

  }

}
