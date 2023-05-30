<script>
  export let detail;
</script>

<div class="ttip">
  <h3>{detail.props.apple_type}</h3>
  <p><span>Min:</span> {detail.props.min}</p>
  <p><span>Mean:</span> {detail.props.mean}</p>
  <p><span>Max:</span> {detail.props.max}</p>
</div>

<style>
  .ttip {
    padding: 5px;
  }
  p {
    margin: 0px;
    margin-top: 5px;
  }
  h3 {
    margin: 10px 0px;
  }
</style>
