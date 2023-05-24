<script>
  /*
    Box plot of apples, with apple SVGs as the chart points
  */
  import { LayerCake, Svg } from 'layercake';
  import { scaleBand, scaleOrdinal } from 'd3-scale';

  import ClevelandDotPlot from '$lib/components/ClevelandDotPlot.svelte';
  import AxisX from '$lib/components/AxisX.svelte';
  import AxisY from '$lib/components/AxisY.svelte';

  // This example loads csv data as json using @rollup/plugin-dsv
  import data from '$lib/constants/scoresByApple.csv';

  const yKey = 'name';
  const xKey = Object.keys(data[0]).filter(d => d !== yKey);

  const seriesColors = ['#f0c', '#00bbff', '#00e047', '#ff7a33'];

  data.forEach(d => {
    xKey.forEach(name => {
      d[name] = +d[name];
    });
  });
</script>

<style>
  /*
    The wrapper div needs to have an explicit width and height in CSS.
    It can also be a flexbox child or CSS grid element.
    The point being it needs dimensions since the <LayerCake> element will
    expand to fill it.
  */
  .chart-container {
    width: 100%;
    height: 250px;
  }
</style>

<div class="chart-container">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={xKey}
    y={yKey}
    yScale={scaleOrdinal()}
    xDomain={[0, null]}
    xPadding={[10, 0]}
    zScale={scaleOrdinal()}
    zDomain={xKey}
    zRange={seriesColors}
    data={data}
  >
    <Svg>
      <AxisX/>
      <AxisY
        ticks={[4]}
        gridlines={false}
      />
      <ClevelandDotPlot/>
    </Svg>
  </LayerCake>
</div>