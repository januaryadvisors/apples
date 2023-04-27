<!--
  @component
  Generates an SVG Cleveland dot plot, also known as a lollipop-chart.
 -->
 <script>
    import { getContext } from 'svelte';
  
    const { data, xGet, yGet, yScale, zScale, config } = getContext('LayerCake');
  
    /** @type {Number} [r=5] - The circle radius. */
    export let r = 5;

    const appleWidth = 25;
    const appleHeight = 25;
  
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
            <!-- <svg width="24" height="23" x={circleX} y={yVal + midHeight} viewBox="0 0 241 232" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M241 111.5C241 178.05 187.05 232 120.5 232C53.9497 232 0 178.05 0 111.5C0 44.9497 60 5.00001 120.5 64C183 0 241 44.9497 241 111.5Z" fill="#D73434"/>
                <path d="M120 25C120 34.3888 120 50 120 65.5C111.5 56.5 95.5 40.3888 95.5 31C95.5 21.6112 110.611 0 120 0C120 0 120 15.6112 120 25Z" fill="#1B7B1F"/>
            </svg> -->
            <svg width="25" height="25" x={circleX - (appleWidth/2)} y={yVal + midHeight - (appleHeight/2)} viewBox="0 0 202 201" fill="none" xmlns="http://www.w3.org/2000/svg">
              <g filter="url(#filter0_i_7_12)">
              <path d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z" fill="#DA3C32"/>
              <path d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z" fill="url(#paint0_radial_7_12)"/>
              </g>
              <path d="M96 0C96 0 102.423 0.5 104.423 2C106.423 3.5 113.423 12.5 112.423 18.5C111.423 24.5 108.423 32.5 109.423 34C110.423 35.5 101 34 101 34L97.5 30.5C97.5 30.5 105.779 26.5 103.423 17.5C101.068 8.5 96 0 96 0Z" fill="url(#paint1_linear_7_12)"/>
              <defs>
              <filter id="filter0_i_7_12" x="-7" y="7" width="208.508" height="193.879" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
              <feFlood flood-opacity="0" result="BackgroundImageFix"/>
              <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
              <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
              <feOffset dx="-7" dy="-10"/>
              <feGaussianBlur stdDeviation="7"/>
              <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1"/>
              <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0"/>
              <feBlend mode="normal" in2="shape" result="effect1_innerShadow_7_12"/>
              </filter>
              <radialGradient id="paint0_radial_7_12" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(8.5 70.5) rotate(88.824) scale(170.536 186.885)">
              <stop stop-color="#F0D33D"/>
              <stop stop-color="#F1D241"/>
              <stop offset="1" stop-color="#F0D33E" stop-opacity="0"/>
              </radialGradient>
              <linearGradient id="paint1_linear_7_12" x1="104.26" y1="0" x2="104.26" y2="34.6667" gradientUnits="userSpaceOnUse">
              <stop stop-color="#7C5A3B"/>
              <stop offset="1" stop-color="#49290B"/>
              </linearGradient>
              </defs>
            </svg>
        {/each}
      </g>
    {/each}
  </g>
  
  <style>
    line {
      stroke-width: 1px;
      stroke: #000;
    }
  </style>