<!--
  @component
  Generates an SVG Cleveland dot plot, also known as a lollipop-chart.
 -->
<script>
  import { createEventDispatcher, getContext } from 'svelte';
  import { raise } from 'layercake';
  import { showAnnotations } from '../../stores';
  import AppleMarker from './AppleMarker.svelte';

  export let annotations;

  // Track screen size
  let screenWidth, isMobile;
  $: isMobile = screenWidth < 600;

  const { data, xGet, yGet, xScale, height } = getContext('LayerCake');

  // Variables to track svg positioning
  let appleWidth, appleHeight;
  $: appleWidth = isMobile ? 28 : 37;
  $: appleHeight = isMobile ? 26 : 33;
  $: midLength = $xScale.bandwidth() / 2;

  // Store hovered apple info for chomp display
  let hoveredAppleInfo;

  const dispatch = createEventDispatcher();

  const handleMouseout = e => {
    dispatch('mouseout');
    hoveredAppleInfo = null;
    e.stopPropagation();
  };

  const handleMousemove = data => {
    return function handleMousemoveFn(e) {
      raise(this);
      // When the element gets raised, it flashes 0,0 for a second so skip that
      if (e.layerX !== 0 && e.layerY !== 0) {
        dispatch('mousemove', { e, props: data });
        hoveredAppleInfo = data;
      }
      e.stopPropagation();
    };
  };
</script>

<svelte:window bind:outerWidth={screenWidth} />

<g class="dot-plot" on:mouseout={handleMouseout} on:blur={handleMouseout}>
  {#each $data as row, rowIndex}
    {@const yVals = $yGet(row)}
    {@const xVal = $xGet(row)}
    <g class="dot-row">
      <line class="light" y1={0} x1={xVal + midLength} y2={$height} x2={xVal + midLength} />
      <line
        y1={Math.min(...yVals)}
        x1={xVal + midLength}
        y2={Math.max(...yVals)}
        x2={xVal + midLength}
      />

      {#each yVals as appleY, i}
        <!-- Currently, only displaying apple graphic for the mean value (at index 0) -->
        {#if i === 0}
          <!-- Add dotted lines connecting apples to annotation text boxes -->
          {#if $showAnnotations && !isMobile && annotations.find(annotationObj => annotationObj.apple_type === row.apple_type)}
            {@const directionMultiplier = rowIndex > $data.length / 2 ? -0.8 : 1}
            {@const annotationLineStartX = xVal + midLength - 20 * directionMultiplier}
            {@const annotationLineStartY = -10}
            {@const annotationLineEndX = xVal + midLength - 20 * directionMultiplier}
            {@const annotationLineEndY = appleY}
            <path
              d="M {annotationLineStartX} {annotationLineStartY} 
                C {annotationLineStartX - 20 * directionMultiplier} {annotationLineStartY + 20}, 
                {annotationLineEndX - 20 * directionMultiplier} {annotationLineEndY - 10}, 
                {annotationLineEndX} {annotationLineEndY}"
              stroke="#999"
              stroke-dasharray={2}
              fill="transparent"
              class="annotation"
            />
          {/if}
          <AppleMarker
            {appleHeight}
            {appleWidth}
            chomp={hoveredAppleInfo != null && hoveredAppleInfo.apple_type === row.apple_type}
            handleMousemove={handleMousemove({
              apple_type: row.apple_type,
              values: [
                ['Taste min', row.min],
                ['Taste mean', row.mean],
                ['Taste max', row.max],
              ],
            })}
            x={xVal + midLength}
            y={appleY}
          />
        {/if}
      {/each}
    </g>
  {/each}
</g>

<style>
  line {
    stroke-width: 7px;
    stroke: #eed8a0;
    stroke-linecap: round;
  }
  line.light {
    stroke-width: 1px;
    stroke: rgba(0, 0, 0, 0.2);
  }
</style>
