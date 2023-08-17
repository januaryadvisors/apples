<!--
  @component
  Generates an SVG area shape using the `area` function from [d3-shape](https://github.com/d3/d3-shape).
 -->
<script>
  import { createEventDispatcher, getContext } from 'svelte';
  import { raise } from 'layercake';
  import AppleMarker from './AppleMarker.svelte';

  // Track screen size
  let screenWidth, isMobile;
  $: isMobile = screenWidth < 600;

  const { data, xGet, yGet, height, yScale } = getContext('LayerCake');

  // Variables to track svg positioning
  let appleWidth, appleHeight;
  $: appleWidth = isMobile ? 28 : 37;
  $: appleHeight = isMobile ? 26 : 33;

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

  export let appleName, expectedMin, expectedMax, expectedMean, tasteMin, tasteMax, tasteMean;

  $: path =
    'M' +
    $data
      .map(d => {
        return $xGet(d) + ',' + $yGet(d);
      })
      .join('L');

  $: tasteX = $xGet($data[1]);
</script>

<!-- Expected taste min-max -->
<line
  x1={0}
  x2={0}
  y1={(5 - expectedMax) * $yScale(4)}
  y2={(5 - expectedMin) * $yScale(4)}
  class="path-line"
/>

<!-- Main line -->
<path class="path-line" d={path} />

<!-- Taste min-max -->
<line
  x1={tasteX}
  x2={tasteX}
  y1={(5 - tasteMax) * $yScale(4)}
  y2={(5 - tasteMin) * $yScale(4)}
  class="path-line"
/>

<!-- Expected taste marker for mean -->
<g on:mouseout={handleMouseout} on:blur={handleMouseout}>
  <AppleMarker
    {appleHeight}
    {appleWidth}
    chomp={hoveredAppleInfo != null &&
      hoveredAppleInfo.apple_type === appleName &&
      hoveredAppleInfo.dataType === 'expected'}
    handleMousemove={handleMousemove({
      apple_type: appleName,
      dataType: 'expected',
      values: [
        ['Expected min', expectedMin],
        ['Expected mean', expectedMean],
        ['Expected max', expectedMax],
      ],
    })}
    x={0}
    y={(5 - expectedMean) * $yScale(4)}
  />
</g>

<!-- Taste marker for mean -->
<g on:mouseout={handleMouseout} on:blur={handleMouseout}>
  <AppleMarker
    {appleHeight}
    {appleWidth}
    chomp={hoveredAppleInfo != null &&
      hoveredAppleInfo.apple_type === appleName &&
      hoveredAppleInfo.dataType === 'taste'}
    handleMousemove={handleMousemove({
      apple_type: appleName,
      dataType: 'taste',
      values: [
        ['Taste min', tasteMin],
        ['Taste mean', tasteMean],
        ['Taste max', tasteMax],
      ],
    })}
    x={tasteX}
    y={(5 - tasteMean) * $yScale(4)}
  />
</g>

<style>
  .path-line {
    stroke: #eed8a0;
    stroke-width: 4px;
    stroke-linejoin: round;
    stroke-linecap: round;
  }
</style>
