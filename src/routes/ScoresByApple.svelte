<script>
  /*
    Box plot of apples, with apple SVGs as the chart points
  */
  import { Html, LayerCake, Svg } from 'layercake';
  import { scaleBand } from 'd3-scale';
  import AxisX from '$lib/components/AxisX.svelte';
  import AxisY from '$lib/components/AxisY.svelte';

  // This example loads csv data as json using @rollup/plugin-dsv
  import rawData from '$lib/constants/summaryScores.csv';
  import VerticalLinePlot from '$lib/components/VerticalLinePlot.svelte';
  import Tooltip from '$lib/components/Tooltip.svelte';
  import AppleTooltip from './AppleTooltip.svelte';

  // Sorting options & selection, initialized to popular
  const DIVISIVE_SORT = (a, b) => Math.abs(b.max - b.min) - Math.abs(a.max - a.min);
  const POPULAR_SORT = (a, b) => b.mean - a.mean;
  const NAME_SORT = (a, b) => a.apple_type.localeCompare(b.apple_type);
  const sortOptions = [POPULAR_SORT, DIVISIVE_SORT, NAME_SORT];
  let currentSortIndex = 0;

  let data = rawData
    .filter(appleRow => appleRow.metric === 'taste')
    .map(appleRow => {
      const { metric, ...coreAppleData } = appleRow;
      return coreAppleData;
    });

  const xKey = 'apple_type';
  const yKey = Object.keys(data[0]).filter(d => d !== xKey);
  let evt; // for tooltip
  let hideTooltip = true;

  data.forEach(d => {
    yKey.forEach(name => {
      d[name] = +d[name];
    });
  });
</script>

<div class="sorting-section">
  <h3>Sort by</h3>
  <div class="sorting-buttons">
    <button class:selected={currentSortIndex === 0} on:click={() => (currentSortIndex = 0)}
      >Popularity</button
    >
    <button class:selected={currentSortIndex === 1} on:click={() => (currentSortIndex = 1)}
      >Divisiveness</button
    >
    <button class:selected={currentSortIndex === 2} on:click={() => (currentSortIndex = 2)}
      >Name</button
    >
  </div>
</div>
<div class="chart-container">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={xKey}
    y={yKey}
    xScale={scaleBand().paddingInner([0.05]).round(true)}
    xDomain={data.sort(sortOptions[currentSortIndex]).map(d => d.apple_type)}
    yDomain={[0, null]}
    yPadding={[10, 0]}
    data={data.sort(sortOptions[currentSortIndex])}
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
        on:mousemove={event => (evt = hideTooltip = event)}
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
  .sorting-section {
    margin-bottom: 40px;
    display: flex;
    align-items: center;
  }
  .sorting-section h3 {
    margin: 0px;
    margin-right: 10px;
  }
  .sorting-buttons {
    display: flex;
  }
  .sorting-buttons button {
    color: #3d3dba;
    padding: 6px 12px;
    font-size: 1rem;
    border: 1px solid #3d3dba;
    border-right: 0px;
    background-color: white;
  }
  .sorting-buttons button:last-child {
    border-radius: 0px 6px 6px 0px;
    border-right: 1px solid #3d3dba;
  }
  .sorting-buttons button:first-child {
    border-radius: 6px 0px 0px 6px;
  }
  .sorting-buttons button.selected {
    color: white;
    background-color: #3d3dba;
  }
</style>
