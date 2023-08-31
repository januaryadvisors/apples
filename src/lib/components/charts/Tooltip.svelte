<!--
  @component
  Generates a hover tooltip. It creates a slot with an exposed variable via `let:detail` that contains information about the event. Use the slot to populate the body of the tooltip using the exposed variable `detail`.
 -->
<script>
  /** @type {Object} evt - A svelte event created via [`dispatch`](https://svelte.dev/docs#createEventDispatcher) with event information under `evt.detail.e`. */
  export let evt = {};

  /** @type {Number} [offset=-35] - A y-offset from the hover point, in pixels. */
  export let offsetY = -35;

  export let parentEl;

  let tooltipXConstrained;
  let tooltipY;

  $: {
    const bounds = parentEl.getBoundingClientRect();
    const tooltipX = evt.detail ? evt.detail.e.clientX - bounds.left : 0;
    tooltipY = evt.detail ? evt.detail.e.clientY - bounds.top + offsetY : 0;
    const minX = 100 - bounds.left;
    const maxX = window.innerWidth - bounds.left - 100;
    tooltipXConstrained = Math.min(maxX, Math.max(minX, tooltipX));
  }
</script>

{#if evt.detail}
  <div
    class="tooltip"
    style="
      top:{tooltipY}px;
      left:{tooltipXConstrained}px;
    "
  >
    <slot detail={evt.detail} />
  </div>
{/if}

<style>
  .tooltip {
    position: absolute;
    width: 160px;
    border: 1px solid #c5bb97;
    font-size: 13px;
    background: rgba(255, 255, 255, 1);
    transform: translate(-50%, -100%);
    z-index: 15;
    border-radius: 6px;
    box-shadow: 0px 3px 6px 0px rgba(0, 0, 0, 0.1);
  }
</style>
