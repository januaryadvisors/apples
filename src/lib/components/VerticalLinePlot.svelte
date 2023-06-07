<!--
  @component
  Generates an SVG Cleveland dot plot, also known as a lollipop-chart.
 -->
<script>
  import { createEventDispatcher, getContext } from 'svelte';
  import { raise } from 'layercake';

  const { data, xGet, yGet, xScale, height } = getContext('LayerCake');

  // Variables to track svg positioning
  const appleWidth = 37;
  const appleHeight = 33;
  $: midLength = $xScale.bandwidth() / 2;

  // Store hovered apple info for chomp display
  let hoveredAppleInfo;

  const dispatch = createEventDispatcher();

  const handleMouseout = e => {
    dispatch('mouseout');
    hoveredAppleInfo = null;
    e.stopPropagation();
  };

  const handleMousemove = row => {
    return function handleMousemoveFn(e) {
      raise(this);
      // When the element gets raised, it flashes 0,0 for a second so skip that
      if (e.layerX !== 0 && e.layerY !== 0) {
        dispatch('mousemove', { e, props: row });
        hoveredAppleInfo = row;
      }
      e.stopPropagation();
    };
  };
</script>

<g class="dot-plot" on:mouseout={handleMouseout} on:blur={handleMouseout}>
  {#each $data as row}
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
          <svg
            class="apple"
            width="{appleWidth}px"
            height="{appleHeight}px"
            y={appleY - appleHeight / 2}
            x={xVal + midLength - appleWidth / 2}
            viewBox="0 0 237 201"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            on:mouseover={handleMousemove(row, true)}
            on:focus={handleMousemove(row, true)}
            on:mousemove={handleMousemove(row)}
          >
            <g filter="url(#filter0_i_123_99)">
              <path
                d="M210.547 104.299C197.547 162.299 163.547 210.299 116.547 199.299C66.5472 209.299 24.5472 165.799 12.5472 104.299C0.547168 42.7986 60.5472 6.2986 116.547 19.7986C171.547 8.2986 223.323 47.2986 210.547 104.299Z"
                fill="#DA3C32"
              />
              <path
                d="M210.547 104.299C197.547 162.299 163.547 210.299 116.547 199.299C66.5472 209.299 24.5472 165.799 12.5472 104.299C0.547168 42.7986 60.5472 6.2986 116.547 19.7986C171.547 8.2986 223.323 47.2986 210.547 104.299Z"
                fill="url(#paint0_radial_123_99)"
              />
            </g>
            <path
              d="M107 0C107 0 113.423 0.5 115.423 2C117.423 3.5 124.423 12.5 123.423 18.5C122.423 24.5 119.423 32.5 120.423 34C121.423 35.5 112 34 112 34L108.5 30.5C108.5 30.5 116.779 26.5 114.423 17.5C112.068 8.5 107 0 107 0Z"
              fill="url(#paint1_linear_123_99)"
            />
            {#if hoveredAppleInfo != null && hoveredAppleInfo.apple_type === row.apple_type}
              <g class="chomp">
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M27.4607 100.04C27.464 99.8176 27.4618 99.5937 27.4539 99.3686C27.1977 92.0328 21.0432 86.2935 13.7073 86.5497C6.3714 86.8059 0.63217 92.9605 0.888344 100.296C1.1216 106.976 6.24503 112.332 12.6977 113.043C9.53907 119.042 7.74077 127.264 8.05523 136.269C8.68144 154.201 17.4487 168.449 27.6374 168.094C30.0543 168.009 32.3342 167.111 34.3976 165.549C34.2927 166.303 34.2513 167.075 34.2787 167.862C34.5349 175.198 40.6895 180.937 48.0253 180.681C55.3612 180.424 61.1005 174.27 60.8443 166.934C60.7458 164.113 59.7753 161.529 58.2009 159.43C62.1824 157.016 64.7759 152.577 64.6019 147.593C64.4304 142.684 61.6181 138.491 57.5781 136.33C59.769 133.866 61.0527 130.589 60.9286 127.034C60.6724 119.698 54.5179 113.959 47.182 114.215C47.0716 114.219 46.9617 114.224 46.8521 114.231C47.0349 113.273 47.1144 112.279 47.0789 111.263C46.8227 103.928 40.6681 98.1883 33.3323 98.4445C31.2051 98.5188 29.2121 99.089 27.4607 100.04Z"
                  fill="white"
                />
                <g filter="url(#filter1_i_123_99)">
                  <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M34.3069 166.401C34.328 166.115 34.3584 165.831 34.3975 165.549C34.0503 165.812 33.6969 166.056 33.3378 166.281C33.659 166.334 33.9821 166.375 34.3069 166.401ZM57.6147 179.992C56.0724 180.046 54.5785 179.854 53.1708 179.451C57.8614 177.265 61.0362 172.431 60.8443 166.934C60.7458 164.113 59.7753 161.529 58.2009 159.43C62.1824 157.016 64.7759 152.577 64.6018 147.593C64.4304 142.684 61.6181 138.491 57.578 136.33C59.769 133.866 61.0527 130.589 60.9286 127.034C60.6724 119.698 54.5178 113.959 47.182 114.215C47.0716 114.219 46.9616 114.224 46.852 114.231C47.0348 113.273 47.1144 112.279 47.0789 111.263C46.8227 103.928 40.6681 98.1883 33.3323 98.4445C31.2051 98.5188 29.2121 99.089 27.4607 100.04C27.464 99.8176 27.4618 99.5937 27.4539 99.3687C27.1977 92.0328 21.0432 86.2935 13.7073 86.5497C12.7829 86.582 11.8839 86.7079 11.019 86.9181C13.5038 84.361 16.9414 82.7227 20.7861 82.5884C27.6211 82.3497 33.504 86.9425 35.1472 93.3008C37.1085 92.1705 39.3671 91.4902 41.7871 91.4057C49.6894 91.1297 56.3192 97.3121 56.5952 105.214C56.6334 106.309 56.5478 107.379 56.3508 108.411C56.4689 108.404 56.5874 108.398 56.7062 108.394C64.6086 108.118 71.2384 114.301 71.5143 122.203C71.6481 126.032 70.2653 129.563 67.9051 132.216C72.2571 134.544 75.2866 139.062 75.4712 144.35C75.6587 149.719 72.8649 154.5 68.576 157.101C70.272 159.361 71.3174 162.145 71.4235 165.184C71.6995 173.086 65.5171 179.716 57.6147 179.992Z"
                    fill="#EEE7D0"
                  />
                </g>
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M196.281 84.3113C196.231 84.1082 196.185 83.9028 196.145 83.6952C194.829 76.9252 199.443 70.3328 206.452 68.9706C213.46 67.6083 220.208 71.9922 221.523 78.7621C222.722 84.9263 219.003 90.9434 213.038 92.9991C217.307 97.8023 220.758 104.936 222.374 113.246C225.591 129.795 220.308 144.744 210.574 146.636C208.265 147.085 205.913 146.758 203.625 145.778C203.885 146.445 204.088 147.143 204.23 147.869C205.545 154.639 200.931 161.232 193.923 162.594C186.915 163.956 180.167 159.572 178.851 152.802C178.345 150.199 178.716 147.622 179.762 145.359C175.475 144.016 172.074 140.518 171.18 135.918C170.299 131.388 172.074 126.938 175.444 124.081C172.844 122.303 170.931 119.583 170.293 116.302C168.977 109.532 173.591 102.94 180.6 101.577C180.705 101.557 180.81 101.538 180.916 101.52C180.539 100.683 180.252 99.7909 180.07 98.8534C178.754 92.0835 183.369 85.491 190.377 84.1288C192.409 83.7338 194.419 83.8219 196.281 84.3113Z"
                  fill="white"
                />
                <g filter="url(#filter2_i_123_99)">
                  <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M203.669 145.893C203.655 145.854 203.64 145.816 203.626 145.778C203.676 145.8 203.726 145.821 203.776 145.842C203.741 145.859 203.705 145.876 203.669 145.893ZM181.142 164.497C183.321 164.073 185.306 163.24 187.014 162.104C182.926 160.669 179.716 157.251 178.851 152.802C178.345 150.199 178.716 147.622 179.762 145.359C175.475 144.016 172.074 140.518 171.18 135.918C170.299 131.388 172.074 126.938 175.444 124.08C172.844 122.303 170.931 119.583 170.293 116.302C168.977 109.532 173.592 102.94 180.6 101.577C180.705 101.557 180.81 101.538 180.916 101.52C180.539 100.683 180.252 99.7909 180.07 98.8534C178.754 92.0834 183.369 85.491 190.377 84.1288C192.409 83.7338 194.419 83.8219 196.281 84.3113C196.231 84.1082 196.186 83.9028 196.145 83.6951C194.829 76.9252 199.444 70.3328 206.452 68.9705C207.533 68.7604 208.608 68.687 209.658 68.738C206.406 66.3643 202.023 65.3068 197.524 66.1812C190.523 67.5422 185.534 73.1371 185.238 79.3789C182.999 78.7906 180.556 78.6859 178.077 79.1677C169.982 80.7412 164.577 87.9744 166.006 95.3235C166.204 96.3412 166.522 97.3078 166.946 98.2137C166.824 98.2346 166.702 98.2569 166.58 98.2805C158.485 99.8541 153.081 107.087 154.509 114.436C155.202 117.998 157.371 120.932 160.345 122.833C156.423 125.986 154.32 130.851 155.276 135.769C156.246 140.762 160.121 144.524 165.045 145.929C163.809 148.405 163.349 151.214 163.898 154.04C165.326 161.389 173.047 166.071 181.142 164.497Z"
                    fill="#EEE7D0"
                  />
                </g>
              </g>
            {/if}
            <defs>
              <filter
                id="filter0_i_123_99"
                x="4"
                y="7"
                width="208.508"
                height="193.879"
                filterUnits="userSpaceOnUse"
                color-interpolation-filters="sRGB"
              >
                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
                <feColorMatrix
                  in="SourceAlpha"
                  type="matrix"
                  values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                  result="hardAlpha"
                />
                <feOffset dx="-7" dy="-10" />
                <feGaussianBlur stdDeviation="7" />
                <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1" />
                <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.15 0" />
                <feBlend mode="normal" in2="shape" result="effect1_innerShadow_123_99" />
              </filter>
              <filter
                id="filter1_i_123_99"
                x="10.019"
                y="82.5795"
                width="65.4612"
                height="98.4214"
                filterUnits="userSpaceOnUse"
                color-interpolation-filters="sRGB"
              >
                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
                <feColorMatrix
                  in="SourceAlpha"
                  type="matrix"
                  values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                  result="hardAlpha"
                />
                <feOffset dx="-1" dy="1" />
                <feGaussianBlur stdDeviation="1.5" />
                <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1" />
                <feColorMatrix
                  type="matrix"
                  values="0 0 0 0 0.8875 0 0 0 0 0.807773 0 0 0 0 0.525104 0 0 0 1 0"
                />
                <feBlend mode="normal" in2="shape" result="effect1_innerShadow_123_99" />
              </filter>
              <filter
                id="filter2_i_123_99"
                x="154.281"
                y="65.8768"
                width="57.3773"
                height="98.9246"
                filterUnits="userSpaceOnUse"
                color-interpolation-filters="sRGB"
              >
                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
                <feColorMatrix
                  in="SourceAlpha"
                  type="matrix"
                  values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                  result="hardAlpha"
                />
                <feOffset dx="2" />
                <feGaussianBlur stdDeviation="1.5" />
                <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1" />
                <feColorMatrix
                  type="matrix"
                  values="0 0 0 0 0.8875 0 0 0 0 0.807773 0 0 0 0 0.525104 0 0 0 1 0"
                />
                <feBlend mode="normal" in2="shape" result="effect1_innerShadow_123_99" />
              </filter>
              <radialGradient
                id="paint0_radial_123_99"
                cx="0"
                cy="0"
                r="1"
                gradientUnits="userSpaceOnUse"
                gradientTransform="translate(19.5 70.5) rotate(88.824) scale(170.536 186.885)"
              >
                <stop stop-color="#F0D33D" />
                <stop stop-color="#F1D241" />
                <stop offset="1" stop-color="#F0D33E" stop-opacity="0" />
              </radialGradient>
              <linearGradient
                id="paint1_linear_123_99"
                x1="115.26"
                y1="0"
                x2="115.26"
                y2="34.6667"
                gradientUnits="userSpaceOnUse"
              >
                <stop stop-color="#7C5A3B" />
                <stop offset="1" stop-color="#49290B" />
              </linearGradient>
            </defs>
          </svg>
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
  svg {
    position: absolute;
  }
  svg.apple {
    z-index: 100;
  }
  .chomp {
    pointer-events: none;
  }
</style>
