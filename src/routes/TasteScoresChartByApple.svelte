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

	console.log(data);
</script>

<div style="width: 100%; height: 400px; marginTop: 40px; paddingBottom: 60px">
  <LayerCake
    padding={{ right: 10, bottom: 20, left: 30 }}
    x={"x"}
    y={"y"}
    xDomain={[0, 1]}
    yDomain={[0, null]}
    yPadding={[10, 0]}
    data={[{x: 0, y: 3}, {x: 1, y: 5}]}
  >
    <Html pointerEvents={false}>
      {#if hideTooltip !== true}
        <Tooltip {evt} let:detail>
          <AppleTooltip {detail} />
        </Tooltip>
      {/if}
    </Html>
    <Svg>
      <AxisY gridlines={false} />
      <Line />
    </Svg>
  </LayerCake>
</div>