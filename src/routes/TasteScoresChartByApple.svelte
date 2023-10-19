<script>
  /*
		Box plot of apples, with apple SVGs as the chart points
	*/
  import { currentRankFilter, showExpectationAnnotations } from '$lib/stores';

  import { LayerCake, Svg } from 'layercake';
  import AxisX from '$lib/components/charts/AxisX.svelte';
  import AxisY from '$lib/components/charts/AxisY.svelte';
  import Line from '$lib/components/charts/Line.svelte';

  // This example loads csv data as json using @rollup/plugin-dsv
  import rawData from '$lib/constants/summaryScores.csv';
  import Tooltip from '$lib/components/charts/Tooltip.svelte';
  import AppleTooltip from './AppleTooltip.svelte';

  let ranks = [
    { key: 'better', label: 'better than we expected' },
    { key: 'same', label: 'similar to how we expected' },
    { key: 'worse', label: 'worse than expected' },
  ];

  let data = rawData
    .filter(appleRow => appleRow.metric === 'taste' || appleRow.metric === 'expected taste')
    .reduce((group, appleRow) => {
      const { apple_type, metric, ...coreAppleData } = appleRow;
      group[apple_type] = group[apple_type] || {};
      group[apple_type][metric] = coreAppleData;
      return group;
    }, {});

  let scoreToRank = score => {
    if (score > 0.4) {
      return 'better';
    }
    if (score < -0.4) {
      return 'worse';
    }
    return 'same';
  };

  let rankedApples = Object.entries(data)
    .map(([name, datum]) => {
      const rankScore = datum['taste'].mean - datum['expected taste'].mean;
      return {
        name,
        ...datum,
        rankScore,
        rank: scoreToRank(rankScore),
      };
    })
    .reduce((a, b) => {
      const { rank } = b;
      a[rank] = a[rank] || [];
      a[rank].push(b);
      return a;
    }, {});

  for (const k in rankedApples) {
    if (k === 'better') {
      rankedApples[k].sort((a, b) => b.rankScore - a.rankScore);
    } else if (k === 'worse') {
      rankedApples[k].sort((a, b) => a.rankScore - b.rankScore);
    } else {
      rankedApples[k].sort((a, b) => Math.abs(a.rankScore) - Math.abs(b.rankScore));
    }
  }

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

  let tooltipParentEl;

  let annotationText;
  $: {
    if ($currentRankFilter === 'better') {
      annotationText =
        'Not only was <strong>Wild Twist</strong> our favorite apple, but it also showed the biggest improvement between expected and actual taste.';
    }
    if ($currentRankFilter === 'same') {
      annotationText =
        'The <strong>Evercrisp</strong> might rank as the most boring apple. We expected it to taste average...and it did.';
    }
    if ($currentRankFilter === 'worse') {
      annotationText =
        '<strong>Opal Gold</strong> was our biggest disappointment. It lost nearly a whole point after we tasted it.';
    }
  }
</script>

<div class="header">
  <p>
    As the old saying goes, you eat first with your eyes. Before taking a bite, we judged the apples
    by the way we <em>expected</em> them to taste. We compare that score to the actual taste score below.
  </p>
  <div class="header-flex">
    <div class="title-with-sort">
      <h2>Apples that tasted</h2>
      <select on:change={e => currentRankFilter.set(e.target.value)} value={$currentRankFilter}>
        {#each ranks as rankObject}
          <option value={rankObject.key}>{rankObject.label}</option>
        {/each}
      </select>
    </div>
    <div class="checkbox-wrapper">
      <label>
        Show annotations
        <input
          type="checkbox"
          checked={$showExpectationAnnotations}
          on:change={e => showExpectationAnnotations.set(e.target.checked)}
        />
      </label>
    </div>
  </div>
</div>
<div>
  <div clasName="rank-block">
    {#if $showExpectationAnnotations}
      <div class="annotation">{@html annotationText}</div>
    {/if}
    <div id="grid" bind:this={tooltipParentEl}>
      {#if hideTooltip !== true}
        <Tooltip {evt} parentEl={tooltipParentEl} let:detail>
          <AppleTooltip {detail} />
        </Tooltip>
      {/if}
      {#each rankedApples[$currentRankFilter] as d, i}
        <div class="apple-chart">
          <h4 style="display: flex; justify-content: center;">{d.name}</h4>
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
                appleName={d.name}
                expectedMin={d['expected taste']['min']}
                expectedMax={d['expected taste']['max']}
                expectedMean={d['expected taste']['mean']}
                showAnnotation={i === 0 && $showExpectationAnnotations}
                tasteMin={d['taste']['min']}
                tasteMax={d['taste']['max']}
                tasteMean={d['taste']['mean']}
                on:mousemove={event => (evt = hideTooltip = event)}
                on:mouseout={() => (hideTooltip = true)}
              />
            </Svg>
          </LayerCake>
        </div>
      {/each}
    </div>
  </div>
</div>

<style>
  .annotation {
    max-width: 380px;
    border: 1px solid #bbb;
    padding: 8px;
    font-size: 0.86rem;
    border-radius: 3px;
    box-sizing: border-box;
  }
  .header {
    margin: 30px 0px 10px 0px;
    padding-top: 30px;
    border-top: 1px solid #eee;
  }
  .header-flex {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .title-with-sort {
    display: flex;
    justify-content: flex-start;
    align-items: center;
  }
  select {
    margin-left: 10px;
    font-size: 1.45rem;
    font-weight: 600;
    color: #333;
  }
  #grid {
    display: flex;
    flex-wrap: wrap;
    position: relative;
    gap: 3%;
  }
  .apple-chart {
    width: 22%;
    height: 200px;
    margin-bottom: 100px;
  }
  .checkbox-wrapper {
    background-color: #e1ebfa;
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #acc3e5;
  }
  input {
    position: relative;
    top: 1px;
    /* Scaled up checkbox */
    -ms-transform: scale(1.2); /* IE */
    -moz-transform: scale(1.2); /* FF */
    -webkit-transform: scale(1.2); /* Safari and Chrome */
    -o-transform: scale(1.2); /* Opera */
    transform: scale(1.2);
  }

  @media only screen and (max-width: 600px) {
    h2,
    select {
      font-size: 1.2rem;
    }
    .header-flex {
      flex-direction: column;
      align-items: flex-start;
    }
    .checkbox-wrapper {
      margin-top: 10px;
    }
    .apple-chart {
      width: 100%;
      margin-right: 0;
    }
  }
</style>
