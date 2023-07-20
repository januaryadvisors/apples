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

	let data = rawData
		.filter(appleRow => appleRow.metric === 'taste' || appleRow.metric === 'expected taste')
		.reduce((group, appleRow) => {
			const { apple_type, metric, ...coreAppleData } = appleRow;
			group[apple_type] = group[apple_type] || {};
			group[apple_type][metric] = coreAppleData;
			return group;
		}, []);

	const xKey = 'apple_type';
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

<!-- <div style="width: 100%; height: 400px; marginTop: 40px; paddingBottom: 60px">
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
</div> -->