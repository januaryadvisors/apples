<!--
  @component
  Generates an SVG Cleveland dot plot, also known as a lollipop-chart.
 -->
<script>
  import { createEventDispatcher, getContext } from "svelte";

  const { data, xGet, yGet, xScale, height } = getContext("LayerCake");

  const appleWidth = 30;
  const appleHeight = 30;

  let hoveredAppleInfo;

  $: midLength = $xScale.bandwidth() / 2;

  const dispatch = createEventDispatcher();

  const handleMousemove = (row, onApple) => (e) => {
    dispatch("mousemove", { e, props: row });
    hoveredAppleInfo = row;
  }

  const handleMouseout = () => {
    dispatch("mouseout")
    hoveredAppleInfo = null;
  }
</script>

<g
  class="dot-plot"
  on:mouseout={handleMouseout}
  on:blur={handleMouseout}
>
  {#each $data as row}
    {@const yVals = $yGet(row)}
    {@const xVal = $xGet(row)}
    <g class="dot-row">
      <line
        class="light"
        y1={0}
        x1={xVal + midLength}
        y2={$height}
        x2={xVal + midLength}
      />
      <line
        y1={Math.min(...yVals)}
        x1={xVal + midLength}
        y2={Math.max(...yVals)}
        x2={xVal + midLength}
        on:mouseover={handleMousemove(row)}
        on:focus={handleMousemove(row)}
      />

      {#each yVals as appleY, i}
        <!-- Currently, only displaying apple graphic for the mean value (at index 0) -->
        {#if i === 0}
          {#if hoveredAppleInfo != null && hoveredAppleInfo.apple_type === row.apple_type}
          <svg
            width="{appleWidth}px"
            height="{appleHeight}px"
            y={appleY - appleHeight / 2}
            x={xVal + midLength - appleWidth / 2}
            viewBox="0 0 202 201"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            on:mouseover={handleMousemove(row, true)}
            on:focus={handleMousemove(row, true)}
          >            <g filter="url(#filter0_i_114_38)">
            <path d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z" fill="#DA3C32"/>
            <path d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z" fill="url(#paint0_radial_114_38)"/>
            <path fill-rule="evenodd" clip-rule="evenodd" d="M104.883 196.897C150.259 206.948 183.072 159.964 195.665 103.264C200.89 79.738 195.037 59.3296 182.522 44.4005C180.641 42.3986 178.672 40.4409 176.613 38.5446C146.398 10.7211 104 46.7598 104 46.7598L104 194.936L104.883 196.897Z" fill="url(#paint1_linear_114_38)"/>
            <path fill-rule="evenodd" clip-rule="evenodd" d="M103.066 196.897C55.0594 206.948 20.345 159.964 7.02161 103.264C1.49352 79.738 7.68602 59.3294 20.9266 44.4003C22.9166 42.3985 24.9994 40.4409 27.1781 38.5446C59.1442 10.7211 104 46.7598 104 46.7598L104 194.936L103.066 196.897Z" fill="url(#paint2_linear_114_38)"/>
            <path fill-rule="evenodd" clip-rule="evenodd" d="M104.076 147.176C104.736 147.232 105.403 147.26 106.076 147.26C121.264 147.26 133.576 132.933 133.576 115.26C133.576 97.5867 121.264 83.2598 106.076 83.2598C105.403 83.2598 104.736 83.2879 104.076 83.3431V85.3507C104.736 85.2905 105.403 85.2598 106.076 85.2598C120.159 85.2598 131.576 98.6913 131.576 115.26C131.576 131.828 120.159 145.26 106.076 145.26C105.403 145.26 104.736 145.229 104.076 145.169V147.176Z" fill="#675700" fill-opacity="0.03"/>
            <path fill-rule="evenodd" clip-rule="evenodd" d="M103.5 146.917C102.84 146.972 102.173 147 101.5 147C86.3122 147 74 132.673 74 115C74 97.3269 86.3122 83 101.5 83C102.173 83 102.84 83.0281 103.5 83.0833V85.0909C102.84 85.0307 102.173 85 101.5 85C87.4167 85 76 98.4315 76 115C76 131.569 87.4167 145 101.5 145C102.173 145 102.84 144.969 103.5 144.909V146.917Z" fill="#675700" fill-opacity="0.03"/>
            </g>
            <path d="M96 0C96 0 102.423 0.5 104.423 2C106.423 3.5 113.423 12.5 112.423 18.5C111.423 24.5 108.423 32.5 109.423 34C110.423 35.5 101 34 101 34L97.5 30.5C97.5 30.5 105.779 26.5 103.423 17.5C101.068 8.5 96 0 96 0Z" fill="url(#paint3_linear_114_38)"/>
            <defs>
            <filter id="filter0_i_114_38" x="-7" y="7" width="208.508" height="193.879" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
            <feFlood flood-opacity="0" result="BackgroundImageFix"/>
            <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
            <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
            <feOffset dx="-7" dy="-10"/>
            <feGaussianBlur stdDeviation="7"/>
            <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1"/>
            <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0"/>
            <feBlend mode="normal" in2="shape" result="effect1_innerShadow_114_38"/>
            </filter>
            <radialGradient id="paint0_radial_114_38" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(8.5 70.5) rotate(88.824) scale(170.536 186.885)">
            <stop stop-color="#F0D33D"/>
            <stop stop-color="#F1D241"/>
            <stop offset="1" stop-color="#F0D33E" stop-opacity="0"/>
            </radialGradient>
            <linearGradient id="paint1_linear_114_38" x1="87.576" y1="113.26" x2="210.076" y2="113.26" gradientUnits="userSpaceOnUse">
            <stop stop-color="#E2CE86"/>
            <stop offset="0.246003" stop-color="#F7F2E4"/>
            </linearGradient>
            <linearGradient id="paint2_linear_114_38" x1="121.376" y1="113.26" x2="-8.22444" y2="113.26" gradientUnits="userSpaceOnUse">
            <stop stop-color="#E2CE86"/>
            <stop offset="0.246003" stop-color="#F7F2E4"/>
            </linearGradient>
            <linearGradient id="paint3_linear_114_38" x1="104.26" y1="0" x2="104.26" y2="34.6667" gradientUnits="userSpaceOnUse">
            <stop stop-color="#7C5A3B"/>
            <stop offset="1" stop-color="#49290B"/>
            </linearGradient>
            </defs>
            </svg>
          {:else}
          <svg
            width="{appleWidth}px"
            height="{appleHeight}px"
            y={appleY - appleHeight / 2}
            x={xVal + midLength - appleWidth / 2}
            viewBox="0 0 202 201"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            on:mouseover={handleMousemove(row, true)}
            on:focus={handleMousemove(row, true)}
          >
            <g filter="url(#filter0_i_7_12)">
              <path
                d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z"
                fill="#DA3C32"
              />
              <path
                d="M199.547 104.299C186.547 162.299 152.547 210.299 105.547 199.299C55.5472 209.299 13.5472 165.799 1.54717 104.299C-10.4528 42.7986 49.5472 6.2986 105.547 19.7986C160.547 8.2986 212.323 47.2986 199.547 104.299Z"
                fill="url(#paint0_radial_7_12)"
              />
            </g>
            <path
              d="M96 0C96 0 102.423 0.5 104.423 2C106.423 3.5 113.423 12.5 112.423 18.5C111.423 24.5 108.423 32.5 109.423 34C110.423 35.5 101 34 101 34L97.5 30.5C97.5 30.5 105.779 26.5 103.423 17.5C101.068 8.5 96 0 96 0Z"
              fill="url(#paint1_linear_7_12)"
            />
            <defs>
              <filter
                id="filter0_i_7_12"
                x="-7"
                y="7"
                width="208.508"
                height="193.879"
                filterUnits="userSpaceOnUse"
                color-interpolation-filters="sRGB"
              >
                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                <feBlend
                  mode="normal"
                  in="SourceGraphic"
                  in2="BackgroundImageFix"
                  result="shape"
                />
                <feColorMatrix
                  in="SourceAlpha"
                  type="matrix"
                  values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                  result="hardAlpha"
                />
                <feOffset dx="-7" dy="-10" />
                <feGaussianBlur stdDeviation="7" />
                <feComposite
                  in2="hardAlpha"
                  operator="arithmetic"
                  k2="-1"
                  k3="1"
                />
                <feColorMatrix
                  type="matrix"
                  values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0"
                />
                <feBlend
                  mode="normal"
                  in2="shape"
                  result="effect1_innerShadow_7_12"
                />
              </filter>
              <radialGradient
                id="paint0_radial_7_12"
                cx="0"
                cy="0"
                r="1"
                gradientUnits="userSpaceOnUse"
                gradientTransform="translate(8.5 70.5) rotate(88.824) scale(170.536 186.885)"
              >
                <stop stop-color="#F0D33D" />
                <stop stop-color="#F1D241" />
                <stop offset="1" stop-color="#F0D33E" stop-opacity="0" />
              </radialGradient>
              <linearGradient
                id="paint1_linear_7_12"
                x1="104.26"
                y1="0"
                x2="104.26"
                y2="34.6667"
                gradientUnits="userSpaceOnUse"
              >
                <stop stop-color="#7C5A3B" />
                <stop offset="1" stop-color="#49290B" />
              </linearGradient>
            </defs>
          </svg>
          {/if}
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
