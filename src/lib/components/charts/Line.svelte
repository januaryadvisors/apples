<!--
  @component
  Generates an SVG area shape using the `area` function from [d3-shape](https://github.com/d3/d3-shape).
 -->
<script>
  import { getContext } from 'svelte';

  const { data, xGet, yGet, height, yScale } = getContext('LayerCake');

  export let expectedMin, expectedMax, expectedMean, tasteMin, tasteMax, tasteMean;

  $: path =
    'M' +
    $data
      .map(d => {
        return $xGet(d) + ',' + $yGet(d);
      })
      .join('L');

  $: tasteX = $xGet($data[1]);

  console.log($yScale(4));
</script>

<!-- Expected taste min-max -->
<line
  x1={0}
  x2={0}
  y1={(5 - expectedMax) * $yScale(4)}
  y2={(5 - expectedMin) * $yScale(4)}
  class="path-line"
/>

<!-- Expected taste circle for mean -->
<circle cx={0} cy={(5 - expectedMean) * $yScale(4)} r="8" fill="#eed8a0" />

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

<!-- Taste circle for mean -->
<circle cx={tasteX} cy={(5 - tasteMean) * $yScale(4)} r="8" fill="#eed8a0" />

<style>
  .path-line {
    stroke: #eed8a0;
    stroke-width: 4px;
    stroke-linejoin: round;
    stroke-linecap: round;
  }
</style>
