class BookingsByAgencyChart {
  constructor(args) {
    this.args = args;
  }

  render(targetElement) {

    var svg = d3.select("#bookings-by-population svg"),
        margin = {top: 20, right: 20, bottom: 20, left: 20},
        width = 700 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom,
        g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var gradientMaroon = svg.append("defs")
      .append("linearGradient")
        .attr("id", "gradient-maroon")
    gradientMaroon.append("stop")
        .attr("offset", "0%")
        .attr("stop-color", "#DD5893") // hover: #F36AA9
        .attr("stop-opacity", 1);
    gradientMaroon.append("stop")
        .attr("offset", "100%")
        .attr("stop-color", "#B82C5A") // hover: #E23870
        .attr("stop-opacity", 1);

    var gradientYellow = svg.append("defs")
      .append("linearGradient")
        .attr("id", "gradient-yellow")
    gradientYellow.append("stop")
        .attr("offset", "0%")
        .attr("stop-color", "#FADC00") // hover: #FFE905
        .attr("stop-opacity", 1);
    gradientYellow.append("stop")
        .attr("offset", "100%")
        .attr("stop-color", "#F2B600") // hover: #FFCF02
        .attr("stop-opacity", 1);

    var x0 = d3.scaleBand()
        .rangeRound([0, width])
        .paddingInner(0.1);

    var x1 = d3.scaleBand()
        .padding(0.05);

    var y = d3.scaleLinear()
        .rangeRound([height, 0]);

    var z = d3.scaleOrdinal()
        .range(["#861F41", "#F2B600"]);

    var zGradients = d3.scaleOrdinal()
        .range(['gradient-maroon', 'gradient-yellow']);

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
        .data(function(d) { return keys.map(function(key) { return {key: key, value: d[key]}; }); })
        .enter().append("rect")
          .attr("x", function(d) { return x1(d.key); })
          .attr("y", function(d) { return y(d.value); })
          .attr("width", x1.bandwidth())
          .attr("height", function(d) { return height - y(d.value); })
          .attr("fill", function(d) { return "url(#"+zGradients(d.key)+")" });

      g.append("g")
          .attr("class", "axis")
          .attr("transform", "translate(0," + height + ")")
          .call(d3.axisBottom(x0));

      g.append("g")
          .attr("class", "axis")
          .call(d3.axisLeft(y).ticks(null, "s"))
        .append("text")
          .attr("x", 2)
          .attr("y", y(y.ticks().pop()) + 0.5)
          .attr("dy", "0.32em")
          .attr("fill", "#000")
          .attr("font-weight", "bold")
          .attr("text-anchor", "start")
          .text("Population");

      var legend = g.append("g")
          .attr("font-family", "sans-serif")
          .attr("font-size", 10)
          .attr("text-anchor", "end")
        .selectAll("g")
        .data(keys.slice().reverse())
        .enter().append("g")
          .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

      legend.append("rect")
          .attr("x", width - 19)
          .attr("width", 19)
          .attr("height", 19)
          .attr("fill", z);

      legend.append("text")
          .attr("x", width - 24)
          .attr("y", 9.5)
          .attr("dy", "0.32em")
          .text(function(d) { return d; });
    });
    
  }

}
