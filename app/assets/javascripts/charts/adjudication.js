class AdjudicationChart {
  base_render(targetElementSelector, opts) {
    const targetElement = d3.select(targetElementSelector);

    // clean up previous render of chart, if present
    targetElement.selectAll('svg').remove()

    const renderedWidth = parseInt(targetElement.style('width'));
    const renderedHeight = opts.height || 500;

    const margin = { top: 20, right: 20, bottom: 20, left: 150 };

    const width = renderedWidth - margin.left - margin.right;
    const height = renderedHeight - margin.top - margin.bottom;

    const svg = targetElement.append('svg')
      .attr('preserveAspectRatio', 'none')
      .attr('height', renderedHeight)
      .attr('width', renderedWidth);

    const g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    const svgDefs = svg.append("defs")

    const color = opts.color || 'yellow';

    const gradient = svgDefs.append('linearGradient')
        .attr('id', 'gradient-'+color)
        .attr('x1', '50%')
        .attr('y1', '0%')
        .attr('x2', '50%')
        .attr('y2', '100%')
    const gradientHover = svgDefs.append('linearGradient')
        .attr('id', 'gradient-'+color+'-hover')
        .attr('x1', '50%')
        .attr('y1', '0%')
        .attr('x2', '50%')
        .attr('y2', '100%')
    const gradients = [
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

    const y = d3.scaleBand()
        .rangeRound([0, height])
        .paddingInner(0.2);

    const x = d3.scaleLinear()
        .rangeRound([0, width]);

    const infotip = d3.tip()
      .attr('class', 'infotip-container')
      .offset([-10, 0])
      .html(function(d) {
        return "<div class='infotip "+color+"'><div class='tooltip_label'>"+d.name+"</div><div class='tooltip_body'>Avg length of adjudication: "+d.avg_duration+" days</div></div>"
      })

    svg.call(infotip);

    d3.json(opts.dataUrl, function(response, data) {
      if (data.length === 0) {
        const textWidth = 300
        g.append('text')
          .attr('x', (width-textWidth)/2)
          .attr('y', height/2)
          .attr('width', textWidth)
          .text('No data available for this selection.')

        return; // Terminate execution, as there's nothing to render.
      }
      y.domain(data.map(function(d) { return d.name }));
      x.domain([0, d3.max(data, function(d) { return d.avg_duration })]).nice();

      const durations = data.map(function (d) { return d.avg_duration })
      const average = Math.round(durations.reduce(function(sum, val) { return sum + val }) / data.length)

      const bar = g.append("g")
        .selectAll("g")
        .data(data)
        .enter().append("g")
        .selectAll("rect")
        .data(function(d) { return [d] }) // TODO: this seems silly
        .enter()

      bar.append("rect")
        .attr("x", 0)
        .attr("y", function(d) { return y(d.name); })
        .attr('rx', 3) // border radius
        .attr('ry', 3) // border radius
        .attr("height", y.bandwidth())
        .attr("width", function(d) { return x(d.avg_duration); })
        .attr("class", 'row gradient-'+color)
        .on('mouseover', infotip.show)
        .on('mouseout', infotip.hide);

      bar.append('text')
        .attr('class', 'chart_label')
        .attr('fill', '#5C5C5C')
        .attr('x', function(d) { return x(d.avg_duration) + 5 })
        .attr('y', function(d) { return y(d.name) + y.bandwidth()/2 + 6 }) // 6 is half of 12px text height
        .attr('text-anchor', 'start')
        .text(function(d) { return d.avg_duration });

      const average_line = g.append('g')
      average_line.append('line')
          .attr('x1', function(d) { return x(average) })
          .attr('x2', function(d) { return x(average) })
          .attr('y1', 0)
          .attr('y2', height)
          .attr('stroke-width', 1)
          .attr('stroke', '#5C5C5C')

      average_line.append('text')
        .attr('class', 'chart_label')
        .attr('fill', '#5C5C5C')
        .attr('text-anchor', 'middle')
        .attr('x', function(d) { return x(average) })
        .attr('y', -5)
        .text('Overall average: '+average+' days')

      g.append("g")
          .attr("class", "axis")
          .call(d3.axisLeft(y)
            .ticks(null, "s")
            .tickSize(0)
            .tickPadding(10)
          )
        .append("text")
          .attr("y", 2)
          .attr("x", x(x.ticks().pop()) + 0.5)
          .attr("dy", "0.32em")
          .attr("fill", "#000")
    });
  }
}
