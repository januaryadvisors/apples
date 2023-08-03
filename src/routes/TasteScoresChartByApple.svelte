<script>
  /*
		Box plot of apples, with apple SVGs as the chart points
	*/
  import { Html, LayerCake, Svg } from 'layercake';
  import { scaleBand } from 'd3-scale';
  import AxisX from '$lib/components/charts/AxisX.svelte';
  import AxisY from '$lib/components/charts/AxisY.svelte';
  import Line from '$lib/components/charts/Line.svelte';

  // This example loads csv data as json using @rollup/plugin-dsv
  import rawData from '$lib/constants/summaryScores.csv';
  import VerticalLinePlot from '$lib/components/charts/VerticalLinePlot.svelte';
  import Tooltip from '$lib/components/charts/Tooltip.svelte';
  import AppleTooltip from './AppleTooltip.svelte';
  import { SORT_INFO } from '$lib/helpers/tasteSort.js';
  import { currentTasteSort } from '$lib/stores';
  import { loop_guard } from 'svelte/internal';

  let data = rawData
    .filter(appleRow => appleRow.metric === 'taste' || appleRow.metric === 'expected taste')
    .reduce((group, appleRow) => {
      const { apple_type, metric, ...coreAppleData } = appleRow;
      group[apple_type] = group[apple_type] || {};
      group[apple_type][metric] = coreAppleData;
      return group;
    }, []);

  const yKey = ['mean', 'min', 'max'];
  let evt; // for tooltip
  let hideTooltip = true;

  // convert string data to numbers
  Object.values(data).forEach(d => {
    Object.values(d).forEach(metric => {
      yKey.forEach(name => {
        metric[name] = +metric[name];
      });
    });
  });
</script>

<h2>Taste scores by apple:</h2>

<div id="grid">
  {#each Object.entries(data) as [appleName, d]}
    <div class="apple-chart">
      <h3 style="display: flex; justify-content: center;">{appleName}</h3>
      <LayerCake
        padding={{ right: 50, bottom: 20, left: 50 }}
        x={'x'}
        y={'y'}
        xDomain={[0, 1]}
        yDomain={[0, 5]}
        yPadding={[10, 0]}
        data={[
          { x: 0, y: d['expected taste']['mean'] },
          { x: 1, y: d['taste']['mean'] },
        ]}
      >
        <Html pointerEvents={false}>
          {#if hideTooltip !== true}
            <Tooltip {evt} let:detail>
              <AppleTooltip {detail} />
            </Tooltip>
          {/if}
        </Html>
        <Svg>
          <AxisY />
          <AxisX
            gridlines={false}
            ticks={1}
            formatTick={tick => {
              return tick === 0 ? 'Expected' : 'Taste';
            }}
          />
          <Line
            expectedMin={d['expected taste']['min']}
            expectedMax={d['expected taste']['max']}
            expectedMean={d['expected taste']['mean']}
            tasteMin={d['taste']['min']}
            tasteMax={d['taste']['max']}
            tasteMean={d['taste']['mean']}
          />
        </Svg>
      </LayerCake>
    </div>
  {/each}
</div>

<style>
  #grid {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
  }
  .apple-chart {
    width: 25%;
    height: 200px;
    margin-right: 40px;
    margin-bottom: 100px;
  }

  @media only screen and (max-width: 600px) {
    .apple-chart {
      width: 100%;
      margin-right: 0;
    }
  }
</style>
