class ConditionOfProbationChart {
  constructor(args) {
    this.args = args;
  }

  render(targetElementSelector) {
    var svg = d3.select(targetElementSelector),
        margin = {top: 20, right: 20, bottom: 20, left: 70},
        width = 700 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom,
        g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var svgDefs = svg.append("defs")

    var x = d3.scaleLinear()
      .range([0, width]);

    var y = d3.scaleLinear()
      .range([height, 0]);

    var infotip = d3.tip()
      .attr('class', 'infotip-container')
      .html(function(d) {
        return "<div class='infotip purple'><div class='tooltip_label'>"+d.time+"</div><div class='tooltip_body'>Total bookings: "+d.value+"</div></div>"
      });

    svg.call(infotip);

    d3.json('/bookings_data_over_time', function(response, data) {
      x.domain([0, d3.max(data, function(d) { return d.time })]);
      y.domain([0, d3.max(data, function(d) { return d.value })]).nice();

      const line = d3.line()
        .x(function(d) { return x(d.time) })
        .y(function(d) { return y(d.value) });

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
        .attr('stroke', '#000000')
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
