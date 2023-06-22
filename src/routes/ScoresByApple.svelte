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
  const DIVISIVE_SORT = 'divisive';
  const POPULAR_SORT = 'popular';
  const NAME_SORT = 'name';
  const sortInfo = {
    [DIVISIVE_SORT]: {
      sortFunc: (a, b) => Math.abs(b.max - b.min) - Math.abs(a.max - a.min),
      annotations: [
        {
          apple_type: 'McIntosh',
          annotation: `The <strong>McIntosh</strong> was our most divisive apple. Some loved the texture, while Carly had to spit it out.`,
        },
        {
          apple_type: 'Kanzi',
          annotation: `Everyone agreed - the <strong>Kanzi</strong> is a pretty good apple! All scores were between 3 and 4.`,
        },
      ],
    },
    [POPULAR_SORT]: {
      sortFunc: (a, b) => b.mean - a.mean,
      annotations: [
        {
          apple_type: 'Wild Twist',
          annotation: `<strong>Wild Twist</strong> was the clear crowd favorite, scoring highly across all team members.`,
        },
        {
          apple_type: 'Red Delicious',
          annotation: `<span>Smith was our strongest advocate for the trailing <strong>Red Delicious</strong>.</span><p style="margin: 7px 0px;">"Oh god" - <em>Kelsey</em></p>"C'mon, it's not that bad" - <em>Smith</em>`,
        },
      ],
    },
    [NAME_SORT]: {
      sortFunc: (a, b) => a.apple_type.localeCompare(b.apple_type),
      annotations: [
        {
          apple_type: 'Envy',
          annotation: `<span>Carly knows her <strong>Envy</strong> apple! Jeff tasted them everywhere.</span><p style="margin: 7px 0px;">"That's an envy" - <em>Carly on the Envy</em></p>"That's an envy" - <em>Jeff on the Envy, Sweetango, and Cosmic Crisp</em>`,
        },
        {
          apple_type: 'Ruby Frost',
          annotation: `<span>The <strong>Ruby Frost</strong> wasn't our most divisive apple, but it split some opinions.</span><p style="margin: 7px 0px;">"Oh hell yeah" - <em>Jeff</em></p>"Something's wrong" - <em>Carly</em>`,
        },
      ],
    },
  };
  let currentSort = POPULAR_SORT;

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
  <h3>Sort scores by</h3>
  <div class="sorting-buttons">
    <button
      class:selected={currentSort === POPULAR_SORT}
      on:click={() => (currentSort = POPULAR_SORT)}>Popularity</button
    >
    <button
      class:selected={currentSort === DIVISIVE_SORT}
      on:click={() => (currentSort = DIVISIVE_SORT)}>Divisiveness</button
    >
    <button class:selected={currentSort === NAME_SORT} on:click={() => (currentSort = NAME_SORT)}
      >Name</button
    >
  </div>
</div>
<div class="annotations">
  {#each sortInfo[currentSort].annotations as annotationObj}
    <div class="annotation">
      <div class="content">
        {@html annotationObj.annotation}
      </div>
    </div>
  {/each}
</div>
<div class="chart-container">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={xKey}
    y={yKey}
    xScale={scaleBand().paddingInner([0.05]).round(true)}
    xDomain={data.sort(sortInfo[currentSort].sortFunc).map(d => d.apple_type)}
    yDomain={[0, null]}
    yPadding={[10, 0]}
    data={data.sort(sortInfo[currentSort].sortFunc)}
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
        annotations={sortInfo[currentSort].annotations}
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
  .annotations {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
  }
  .annotation {
    max-width: 230px;
    border: 1px solid #aaa;
    padding: 10px;
    font-size: 0.9rem;
    display: flex;
    justify-content: center;
    flex-direction: column;
  }
  .chart-container {
    width: 100%;
    height: 400px;
    margin-top: 40px;
  }
  .sorting-section {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
  }
  .sorting-section h3 {
    margin: 0px;
    margin-bottom: 10px;
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
