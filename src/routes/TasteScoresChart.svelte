<script>
  /*
    Box plot of apples, with apple SVGs as the chart points
  */
  import { Html, LayerCake, Svg } from 'layercake';
  import { scaleBand } from 'd3-scale';
  import AxisX from '$lib/components/charts/AxisX.svelte';
  import AxisY from '$lib/components/charts/AxisY.svelte';

  // This example loads csv data as json using @rollup/plugin-dsv
  import rawData from '$lib/constants/summaryScores.csv';
  import VerticalLinePlot from '$lib/components/charts/VerticalLinePlot.svelte';
  import Tooltip from '$lib/components/charts/Tooltip.svelte';
  import AppleTooltip from './AppleTooltip.svelte';
  import { SORT_INFO } from '$lib/helpers/tasteSort.js';
  import { currentTasteSort } from '$lib/stores';
  import { DIVISIVE_SORT, NAME_SORT, POPULAR_SORT } from '../lib/helpers/tasteSort';
  import { showAnnotations } from '$lib/stores';

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

<p>
  {SORT_INFO[$currentTasteSort].description}
</p>
<div class="most-least-markers">
  <span>
    {#if $currentTasteSort === NAME_SORT}
      ABC
    {:else}
      Most {$currentTasteSort}
    {/if}
  </span>
  <span class="arrow left" />
  <div class="arrow-line" />
  <span class="arrow right" />
  <span>
    {#if $currentTasteSort === NAME_SORT}
      XYZ
    {:else}
      Least {$currentTasteSort}
    {/if}
  </span>
</div>
{#if $showAnnotations}
  <div class="annotations">
    {#each SORT_INFO[$currentTasteSort].annotations as annotationObj}
      <div class="annotation">
        <div class="content">
          {@html annotationObj.annotation}
        </div>
      </div>
    {/each}
  </div>
{/if}
<div class="chart-container">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={xKey}
    y={yKey}
    xScale={scaleBand().paddingInner([0.05]).round(true)}
    xDomain={data.sort(SORT_INFO[$currentTasteSort].sortFunc).map(d => d.apple_type)}
    yDomain={[0, null]}
    yPadding={[10, 0]}
    data={data.sort(SORT_INFO[$currentTasteSort].sortFunc)}
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
      <AxisX gridlines={false} diagonal={true} />
      <AxisY gridlines={false} />
      <VerticalLinePlot
        annotations={SORT_INFO[$currentTasteSort].annotations}
        on:mousemove={event => (evt = hideTooltip = event)}
        on:mouseout={() => (hideTooltip = true)}
      />
    </Svg>
  </LayerCake>
</div>

<style>
  .most-least-markers {
    display: flex;
    justify-content: stretch;
    align-items: center;
    font-size: 0.7rem;
    color: #777;
    text-transform: uppercase;
  }
  .arrow-line {
    height: 1px;
    background-image: linear-gradient(to right, #bbb, #ddd, #eee, #eee, #ddd, #bbb);
    flex-grow: 1;
  }
  .arrow {
    border: solid #bbb;
    border-width: 0 1px 1px 0;
    display: inline-block;
    padding: 3px;
    position: relative;
  }
  .right {
    transform: rotate(-45deg);
    -webkit-transform: rotate(-45deg);
    right: 7px;
  }

  .left {
    transform: rotate(135deg);
    -webkit-transform: rotate(135deg);
    left: 7px;
  }
  .annotations {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    position: relative;
    margin-top: -20px;
    top: 30px;
    padding: 0px 20px;
  }
  .annotation {
    max-width: 380px;
    border: 1px solid #bbb;
    padding: 8px;
    font-size: 0.86rem;
    display: flex;
    justify-content: center;
    flex-direction: column;
    border-radius: 3px;
    box-sizing: border-box;
  }
  /*
    The wrapper div needs to have an explicit width and height in CSS.
    It can also be a flexbox child or CSS grid element.
    The point being it needs dimensions since the <LayerCake> element will
    expand to fill it.
  */
  .chart-container {
    width: 100%;
    height: 400px;
    margin-top: 40px;
    padding-bottom: 60px;
  }
  @media only screen and (max-width: 600px) {
    .annotations {
      flex-direction: column;
      padding: 0px;
      margin-top: -10px;
      top: 20px;
    }
    .annotation {
      max-width: 100%;
      width: 100%;
      margin-bottom: 10px;
    }
  }
</style>
