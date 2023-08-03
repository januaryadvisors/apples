<!--
  @component
  Generates an SVG area shape using the `area` function from [d3-shape](https://github.com/d3/d3-shape).
 -->
<script>
  import { getContext } from 'svelte';

  const { data, xGet, yGet } = getContext('LayerCake');

  export let expectedMin, expectedMax, expectedMean, tasteMin, tasteMax, tasteMean;

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
<line x1={0} x2={0} y1={(5 - expectedMax) * 54} y2={(5 - expectedMin) * 54} class="path-line" />

<!-- Main line -->
<path class="path-line" d={path} />

<circle cx={0} cy={(5 - expectedMean) * 54} r="9" fill="#eed8a0" />
<circle cx={tasteX} cy={(5 - tasteMean) * 54} r="9" fill="#eed8a0" />

<!-- Taste min-max -->
<line x1={tasteX} x2={tasteX} y1={(5 - tasteMax) * 54} y2={(5 - tasteMin) * 54} class="path-line" />

<style>
  .path-line {
    stroke: #eed8a0;
    stroke-width: 4px;
    stroke-linejoin: round;
    stroke-linecap: round;
  }
</style>
