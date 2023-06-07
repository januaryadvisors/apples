<script>
  export let detail;
</script>

<div class="ttip">
  <h3>{detail.props.apple_type}</h3>
  <div class="content">
    <p><span>Min score</span> {detail.props.min}</p>
    <p><span>Mean score</span> <strong>{detail.props.mean}</strong></p>
    <p><span>Max score</span> {detail.props.max}</p>
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
    padding: 20px 0px;
    padding-bottom: 15px;
    text-align: center;
    background-color: #f2ecd5;
    border-radius: 6px 6px 0px 0px;
    margin: 0px;
  }
</style>
