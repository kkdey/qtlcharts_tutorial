# iplotCurves: Plot of a bunch of curves, linked to points in 0, 1, or 2 scatterplots
# Karl W Broman

iplotCurves = (widgetdiv, curve_data, scatter1_data, scatter2_data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 1000 # total height of chart in pixels
    width =  chartOpts?.width ? 1000 # total width of chart in pixels
    htop = chartOpts?.htop ? height/2 # height of curves chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    pointcolor = chartOpts?.pointcolor ? chartOpts?.color ? null # vector of colors for points in scatterplots
    pointstroke = chartOpts?.pointstroke ? "black" # color of line outline for points in scatterplots
    pointsize = chartOpts?.pointsize ? 3 # size of points in scatterplots
    pointcolorhilit = chartOpts?.pointcolorhilit ? chartOpts?.colorhilit ? null # vector of colors for points in scatterplots, when highlighted
    pointsizehilit = chartOpts?.pointsizehilit ? 6 # zie of points in scatterplot, when highlighted
    strokecolor = chartOpts?.strokecolor ? chartOpts?.color ? null # vector of colors of curves
    strokecolorhilit = chartOpts?.strokecolorhilit ? chartOpts?.colorhilit ? null # vector of colors of curves, when highlighted
    strokewidth = chartOpts?.strokewidth ? 2 # line width of curves
    strokewidthhilit = chartOpts?.strokewidthhilit ? 2 # line widths of curves, when highlighted

    curves_xlim = chartOpts?.curves_xlim ? null # x-axis limits in curve plot
    curves_ylim = chartOpts?.curves_ylim ? null # y-axis limits in curve plot
    curves_nxticks = chartOpts?.curves_nxticks ? 5 # no. ticks on x-axis in curve plot
    curves_xticks = chartOpts?.curves_xticks ? null # vector of tick positions on x-axis in curve plot
    curves_nyticks = chartOpts?.curves_nyticks ? 5 # no. ticks on y-axis in curve plot
    curves_yticks = chartOpts?.curves_yticks ? null # vector of tick positions on y-axis in curve plot
    curves_title = chartOpts?.curves_title ? "" # title for curve plot
    curves_xlab = chartOpts?.curves_xlab ? chartOpts?.xlab ? "X" # x-axis label for curve plot
    curves_ylab = chartOpts?.curves_ylab ? chartOpts?.ylab ? "Y" # y-axis label for curve plot

    scat1_xlim = chartOpts?.scat1_xlim ? null # x-axis limits in first scatterplot
    scat1_ylim = chartOpts?.scat1_ylim ? null # y-axis limits in first scatterplot
    scat1_xNA = chartOpts?.scat1_xNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values for x variable in first scatterplot (handle=T/F, force=T/F, width, gap)
    scat1_yNA = chartOpts?.scat1_yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values for x variable in first scatterplot (handle=T/F, force=T/F, width, gap)
    scat1_nxticks = chartOpts?.scat1_nxticks ? 5 # no. ticks on x-axis in first scatterplot
    scat1_xticks = chartOpts?.scat1_xticks ? null # vector of tick positions on x-axis in first scatterplot
    scat1_nyticks = chartOpts?.scat1_nyticks ? 5 # no. ticks on y-axis in first scatterplot
    scat1_yticks = chartOpts?.scat1_yticks ? null # vector of tick positions on y-axis in first scatterplot
    scat1_title = chartOpts?.scat1_title ? "" # title for first scatterplot
    scat1_xlab = chartOpts?.scat1_xlab ? "X" # x-axis label for first scatterplot
    scat1_ylab = chartOpts?.scat1_ylab ? "Y" # y-axis label for first scatterplot

    scat2_xlim = chartOpts?.scat2_xlim ? null # x-axis limits in second scatterplot
    scat2_ylim = chartOpts?.scat2_ylim ? null # y-axis limits in second scatterplot
    scat2_xNA = chartOpts?.scat2_xNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values for x variable in second scatterplot (handle=T/F, force=T/F, width, gap)
    scat2_yNA = chartOpts?.scat2_yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values for x variable in second scatterplot (handle=T/F, force=T/F, width, gap)
    scat2_nxticks = chartOpts?.scat2_nxticks ? 5 # no. ticks on x-axis in second scatterplot
    scat2_xticks = chartOpts?.scat2_xticks ? null # vector of tick positions on x-axis in second scatterplot
    scat2_nyticks = chartOpts?.scat2_nyticks ? 5 # no. ticks on y-axis in second scatterplot
    scat2_yticks = chartOpts?.scat2_yticks ? null # vector of tick positions on y-axis in second scatterplot
    scat2_title = chartOpts?.scat2_title ? "" # title for second scatterplot
    scat2_xlab = chartOpts?.scat2_xlab ? "X" # x-axis label for second scatterplot
    scat2_ylab = chartOpts?.scat2_ylab ? "Y" # y-axis label for second scatterplot
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    # number of scatterplots
    nscatter = (scatter1_data?) + (scatter2_data?)

    # panel heights and widths
    htop = if nscatter==0 then height else htop
    hbot = height - htop
    htop = htop - (margin.top + margin.bottom) # remove margins
    hbot = hbot - (margin.top + margin.bottom) # remove margins
    wtop = (width - (margin.left + margin.top))
    wbot = (width - 2*(margin.left + margin.right))/2

    # Select the svg element, if it exists.
    svg = d3.select(widgetdiv).select("svg")

    # groups of colors
    nind = curve_data.data.length
    group = curve_data?.group ? (1 for i in curve_data.data)
    ngroup = d3.max(group)
    group = (g-1 for g in group) # changed from (1,2,3,...) to (0,1,2,...)

    # colors of the points in the different groups
    pointcolor = pointcolor ? selectGroupColors(ngroup, "light")
    pointcolorhilit = pointcolorhilit ? selectGroupColors(ngroup, "dark")
    strokecolor = strokecolor ? selectGroupColors(ngroup, "light")
    strokecolorhilit = strokecolorhilit ? selectGroupColors(ngroup, "dark")

    ## configure the three charts
    mycurvechart = curvechart().width(wtop)
                               .height(htop)
                               .margin(margin)
                               .axispos(axispos)
                               .titlepos(titlepos)
                               .rectcolor(rectcolor)
                               .strokecolor(strokecolor)
                               .strokecolorhilit(strokecolorhilit)
                               .strokewidth(strokewidth)
                               .strokewidthhilit(strokewidthhilit)
                               .xlim(curves_xlim)
                               .ylim(curves_ylim)
                               .nxticks(curves_nxticks)
                               .xticks(curves_xticks)
                               .nyticks(curves_nyticks)
                               .yticks(curves_yticks)
                               .title(curves_title)
                               .xlab(curves_xlab)
                               .ylab(curves_ylab)

    if nscatter > 0
         myscatterplot1 = scatterplot().width(wbot)
                                       .height(hbot)
                                       .margin(margin)
                                       .axispos(axispos)
                                       .titlepos(titlepos)
                                       .rectcolor(rectcolor)
                                       .pointcolor(pointcolor)
                                       .pointstroke(pointstroke)
                                       .pointsize(pointsize)
                                       .xlim(scat1_xlim)
                                       .ylim(scat1_ylim)
                                       .xNA(scat1_xNA)
                                       .yNA(scat1_yNA)
                                       .nxticks(scat1_nxticks)
                                       .xticks(scat1_xticks)
                                       .nyticks(scat1_nyticks)
                                       .yticks(scat1_yticks)
                                       .title(scat1_title)
                                       .xlab(scat1_xlab)
                                       .ylab(scat1_ylab)

    if nscatter == 2
          myscatterplot2 = scatterplot().width(wbot)
                                        .height(hbot)
                                        .margin(margin)
                                        .axispos(axispos)
                                        .titlepos(titlepos)
                                        .rectcolor(rectcolor)
                                        .pointcolor(pointcolor)
                                        .pointstroke(pointstroke)
                                        .pointsize(pointsize)
                                        .xlim(scat2_xlim)
                                        .ylim(scat2_ylim)
                                        .xNA(scat2_xNA)
                                        .yNA(scat2_yNA)
                                        .nxticks(scat2_nxticks)
                                        .xticks(scat2_xticks)
                                        .nyticks(scat2_nyticks)
                                        .yticks(scat2_yticks)
                                        .title(scat2_title)
                                        .xlab(scat2_xlab)
                                        .ylab(scat2_ylab)

    ## now make the actual charts
    g_curves = svg.append("g")
                  .attr("id", "curvechart")
                .datum(curve_data)
                .call(mycurvechart)

    shiftdown = htop+margin.top+margin.bottom
    if nscatter > 0
        g_scat1 = svg.append("g")
                     .attr("id", "scatterplot1")
                     .attr("transform", "translate(0,#{shiftdown})")
                     .datum(scatter1_data)
                     .call(myscatterplot1)

    if nscatter == 2
        g_scat2 = svg.append("g")
                     .attr("id", "scatterplot2")
                     .attr("transform", "translate(#{wbot+margin.left+margin.right},#{shiftdown})")
                     .datum(scatter2_data)
                     .call(myscatterplot2)

    points1 = myscatterplot1.pointsSelect() if nscatter > 0
    points2 = myscatterplot2.pointsSelect() if nscatter == 2
    allpoints = [points1] if nscatter == 1
    allpoints = [points1, points2] if nscatter == 2
    curves = mycurvechart.curvesSelect()

    # expand pointcolor and pointcolorhilit to length of group
    pointcolor = expand2vector(pointcolor, ngroup)
    pointcolorhilit = expand2vector(pointcolorhilit, ngroup)
    strokecolor = expand2vector(strokecolor, ngroup)
    strokecolorhilit = expand2vector(strokecolorhilit, ngroup)

    curves.on "mouseover", (d,i) ->
                             d3.select(this).attr("stroke", strokecolorhilit[group[i]]).moveToFront()
                             d3.selectAll("circle.pt#{i}").attr("r", pointsizehilit) if nscatter > 0
                             d3.selectAll("circle.pt#{i}").attr("fill", pointcolorhilit[group[i]]) if nscatter > 0
          .on "mouseout", (d,i) ->
                             d3.select(this).attr("stroke", strokecolor[group[i]]).moveToBack()
                             d3.selectAll("circle.pt#{i}").attr("r", pointsize) if nscatter > 0
                             d3.selectAll("circle.pt#{i}").attr("fill", pointcolor[group[i]]) if nscatter > 0


    if nscatter > 0
        allpoints.forEach (points) ->
            points.on "mouseover", (d,i) ->
                                       d3.selectAll("circle.pt#{i}").attr("r", pointsizehilit)
                                       d3.selectAll("circle.pt#{i}").attr("fill", pointcolorhilit[group[i]])
                                       d3.select("path.path#{i}").attr("stroke", strokecolorhilit[group[i]]).moveToFront()
                  .on "mouseout", (d,i) ->
                                       d3.selectAll("circle.pt#{i}").attr("r", pointsize)
                                       d3.selectAll("circle.pt#{i}").attr("fill", pointcolor[group[i]])
                                       d3.select("path.path#{i}").attr("stroke", strokecolor[group[i]]).moveToBack()
