<script>
  export let detail;
</script>

<div class="ttip">
  <h3>{detail.props.apple_type}</h3>
  <div class="content">
    {#each detail.props.values as value}
      <p><span>{value[0]}</span> {value[1]}</p>
    {/each}
  </div>
</div>

<style>
  .ttip {
    color: #251e19;
  }
  .content {
    padding: 15px;
    padding-top: 5px;
  }
  p {
    margin: 0px;
    margin-top: 8px;
    display: flex;
    justify-content: space-between;
  }
  h3 {
    padding: 8px;
    text-align: center;
    background-color: #f2ecd5;
    border-radius: 6px 6px 0px 0px;
    margin: 0px;
  }
</style>
