<script>
  import appleRatingsGraphic from '$lib/assets/labeled_ratings.svg';
  import TasteScoresHeader from '$lib/components/TasteScoresHeader.svelte';
  import TasteScoresChart from './TasteScoresChart.svelte';
</script>

<h1>Title & purpose pending ...</h1>
<p>Intro text ...</p>

<h2>Approach to ranking</h2>
<p>Text on how we generated our rankings? Here's what we landed on:</p>
<div class="ratings-graphic-wrapper">
  <img src={appleRatingsGraphic} alt="Apple ratings graphic" />
</div>

<TasteScoresHeader />
<TasteScoresChart />

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
