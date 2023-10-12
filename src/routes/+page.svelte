<script>
  import appleRatingsGraphic from '$lib/assets/labeled_ratings.svg';
  import TasteScoresHeader from '$lib/components/TasteScoresHeader.svelte';
  import TasteScoresChart from './TasteScoresChart.svelte';
  import TasteScoresChartByApple from './TasteScoresChartByApple.svelte';
</script>

<h1>Core Scores</h1>
<p>
  At January Advisors, our passions run deep. On the surface, we are data nerds, but at our core we
  are apple nerds. Whenever we get together, we conduct elaborate blind taste tests of different
  apple varieties. After slicing the apples, we slice the data, identifying the group’s favorite,
  least favorite, and most contentious apples.
</p>

<h2>Approach to ranking</h2>
<p>
  We scored apples on a 1-5 scale across four criteria. Taste, of course, was one of the factors,
  but we recognized that taste alone doesn't paint the complete picture. Everyone comes in with
  their own deep-seeded biases and assumed preferences. We captured these notions by scoring
  Appearance, Name, and Expectation. These criteria allowed us to separate darkhorse apples that
  outperformed expectations from superficial apples that get by on looks and marketing alone. Our
  scores might inform whether any of us need to reevaluate what we reach for in the produce aisle…
</p>
<div class="ratings-graphic-wrapper">
  <img src={appleRatingsGraphic} alt="Apple ratings graphic" />
</div>

<TasteScoresHeader />
<TasteScoresChart />
<TasteScoresChartByApple />

<style>
  .ratings-graphic-wrapper {
    display: flex;
    justify-content: center;
    margin: 50px 0px;
  }
  .ratings-graphic-wrapper img {
    width: 800px;
    max-width: 100%;
  }
</style>
