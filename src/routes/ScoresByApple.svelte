<script>
  /*
    Box plot of apples, with apple SVGs as the chart points
  */
  import { Html, LayerCake, Svg } from "layercake";
  import { scaleBand } from "d3-scale";
  import AxisX from "$lib/components/AxisX.svelte";
  import AxisY from "$lib/components/AxisY.svelte";

  // This example loads csv data as json using @rollup/plugin-dsv
  import rawData from "$lib/constants/summaryScores.csv";
  import VerticalLinePlot from "$lib/components/VerticalLinePlot.svelte";
  import Tooltip from "$lib/components/Tooltip.svelte";
  import AppleTooltip from "./AppleTooltip.svelte";

  let data = rawData.filter(appleRow => appleRow.metric === 'taste').map((appleRow) => {

    const { metric, ...coreAppleData } = appleRow;
    return coreAppleData;
  });

  const xKey = "apple_type";
  const yKey = Object.keys(data[0]).filter((d) => d !== xKey);
  let evt; // for tooltip
  let hideTooltip = true;

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
    <!-- Tooltip for showing apple details -->
    <Html pointerEvents={false}>
      {#if hideTooltip !== true}
        <Tooltip {evt} let:detail>
          <AppleTooltip {detail} />
        </Tooltip>
      {/if}
    </Html>
    <Svg>
      <AxisX gridlines={false} />
      <AxisY gridlines={false} />
      <VerticalLinePlot
        on:mousemove={(event) => (evt = hideTooltip = event)}
        on:mouseout={() => (hideTooltip = true)}
      />
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
