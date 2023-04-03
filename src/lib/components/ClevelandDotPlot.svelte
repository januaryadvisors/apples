<!--
  @component
  Generates an SVG Cleveland dot plot, also known as a lollipop-chart.
 -->
 <script>
    import { getContext } from 'svelte';
  
    const { data, xGet, yGet, yScale, zScale, config } = getContext('LayerCake');
  
    /** @type {Number} [r=5] - The circle radius. */
    export let r = 5;
  
    $: midHeight = $yScale.bandwidth() / 2;
  </script>
  
  <g class="dot-plot">
    {#each $data as row}
      {@const yVal = $yGet(row)}
      {@const xVals = $xGet(row)}
      <g class="dot-row">
        <line
          x1="{Math.min(...xVals)}"
          y1="{yVal + midHeight}"
          x2="{Math.max(...xVals)}"
          y2="{yVal + midHeight}"
        ></line>
  
        {#each xVals as circleX, i}
            <svg width="24" height="23" x={circleX} y={yVal + midHeight} viewBox="0 0 241 232" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M241 111.5C241 178.05 187.05 232 120.5 232C53.9497 232 0 178.05 0 111.5C0 44.9497 60 5.00001 120.5 64C183 0 241 44.9497 241 111.5Z" fill="#D73434"/>
                <path d="M120 25C120 34.3888 120 50 120 65.5C111.5 56.5 95.5 40.3888 95.5 31C95.5 21.6112 110.611 0 120 0C120 0 120 15.6112 120 25Z" fill="#1B7B1F"/>
            </svg>
            
          <circle
            cx="{circleX}"
            cy="{yVal + midHeight}"
            r="{r}"
            fill="{$zScale($config.x[i])}"
          ></circle>
        {/each}
      </g>
    {/each}
  </g>
  
  <style>
    line {
      stroke-width: 1px;
      stroke: #000;
    }
    circle {
      stroke: #000;
      stroke-width: 1px;
    }
  </style>