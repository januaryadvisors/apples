<script>
  import '$lib/styles/app.css';
</script>

<div class="wrapper">
  <div class="content">
    <slot />
  </div>
</div>

<style>
  .wrapper {
    display: flex;
    justify-content: center;
    padding: 0px 20px;
  }
  .content {
    width: 1100px;
    max-width: 100%;
    padding-bottom: 50px;
  }
</style>
