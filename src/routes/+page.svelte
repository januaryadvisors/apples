<script>
  import AppleBoxPlot from './AppleBoxPlot.svelte';
  import appleRatingsGraphic from '$lib/assets/labeled_ratings.svg';
  import ScoresByApple from './ScoresByApple.svelte';
</script>

<h1>Title & purpose pending ...</h1>
<p>Intro text ...</p>

<h2>Approach to ranking</h2>
<p>Text on how we generated our rankings? Here's what we landed on:</p>
<div class="ratings-graphic-wrapper">
  <img src={appleRatingsGraphic} alt="Apple ratings graphic" />
</div>

<h2>Our apple scores</h2>
<div style="margin: 30px 0px;">
  <ScoresByApple />
</div>

<style>
  .ratings-graphic-wrapper {
    display: flex;
    justify-content: center;
    margin: 20px 0px;
  }
  .ratings-graphic-wrapper img {
    width: 800px;
    max-width: 100%;
  }
</style>
