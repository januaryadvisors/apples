<script>
  /*
    Box plot of apples, with apple SVGs as the chart points
  */
  import { LayerCake, Svg } from "layercake";
  import { scaleBand, scaleOrdinal } from "d3-scale";
  import AxisX from "$lib/components/AxisX.svelte";
  import AxisY from "$lib/components/AxisY.svelte";

  // This example loads csv data as json using @rollup/plugin-dsv
  import data from "$lib/constants/appleScores.csv";
  import VerticalLinePlot from "../lib/components/VerticalLinePlot.svelte";

  const xKey = "apple_name";
  const yKey = Object.keys(data[0]).filter((d) => d !== xKey);

  data.forEach((d) => {
    yKey.forEach((name) => {
      d[name] = +d[name];
    });
  });
</script>

<div class="chart-container">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={xKey}
    y={yKey}
    xScale={scaleBand().paddingInner([0.05]).round(true)}
    yDomain={[0, null]}
    yPadding={[10, 0]}
    {data}
  >
    <Svg>
      <AxisX gridlines={false} />
      <AxisY gridlines={false} />
      <VerticalLinePlot />
    </Svg>
  </LayerCake>
</div>

<style>
  /*
    The wrapper div needs to have an explicit width and height in CSS.
    It can also be a flexbox child or CSS grid element.
    The point being it needs dimensions since the <LayerCake> element will
    expand to fill it.
  */
  .chart-container {
    width: 100%;
    height: 400px;
  }
</style>
