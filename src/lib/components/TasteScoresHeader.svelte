<script>
  import { currentTasteSort, showAnnotations } from '$lib/stores';
  import { DIVISIVE_SORT, NAME_SORT, POPULAR_SORT } from '../helpers/tasteSort';
</script>

<div class="header">
  <div class="title-with-sort">
    <h2>Apple taste scores, sorted</h2>
    <select on:change={e => currentTasteSort.set(e.target.value)} value={$currentTasteSort}>
      <option value={POPULAR_SORT}>by popularity</option>
      <option value={DIVISIVE_SORT}>by divisiveness</option>
      <option value={NAME_SORT}>alphabetically</option>
    </select>
  </div>
  <div class="checkbox-wrapper">
    <label>
      Show annotations
      <input
        type="checkbox"
        checked={$showAnnotations}
        on:change={e => showAnnotations.set(e.target.checked)}
      />
    </label>
  </div>
</div>

<style>
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 30px 0px 10px 0px;
    padding-top: 30px;
    border-top: 1px solid #eee;
  }
  .title-with-sort {
    display: flex;
    justify-content: flex-start;
    align-items: center;
  }
  h2 {
    margin: 0px;
  }
  select {
    margin-left: 10px;
    font-size: 1.45rem;
    font-weight: 600;
    color: #333;
  }
  .checkbox-wrapper {
    background-color: #e1ebfa;
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #acc3e5;
  }
  input {
    position: relative;
    top: 1px;
    /* Scaled up checkbox */
    -ms-transform: scale(1.2); /* IE */
    -moz-transform: scale(1.2); /* FF */
    -webkit-transform: scale(1.2); /* Safari and Chrome */
    -o-transform: scale(1.2); /* Opera */
    transform: scale(1.2);
  }
  @media only screen and (max-width: 600px) {
    h2,
    select {
      font-size: 1.2rem;
    }
    .header {
      flex-direction: column;
      align-items: flex-start;
    }
    .checkbox-wrapper {
      margin-top: 10px;
    }
  }
</style>
