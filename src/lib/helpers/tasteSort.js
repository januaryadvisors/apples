// Sorting options for apple tasting chart
export const DIVISIVE_SORT = 'divisive';
export const POPULAR_SORT = 'popular';
export const NAME_SORT = 'name';

// Sort functions and annotations per sort option
export const SORT_INFO = {
  [POPULAR_SORT]: {
    sortFunc: (a, b) => b.mean - a.mean,
    description: 'Apples sorted from highest average taste score to lowest average taste score.',
    annotations: [
      {
        apple_type: 'Wild Twist',
        annotation: `<strong>Wild Twist</strong> was the clear crowd favorite, scoring highly across all team members.`,
      },
      {
        apple_type: 'Red Delicious',
        annotation: `<span>Smith was our strongest advocate for the <strong>Red Delicious</strong>.</span> <div style="margin-top: 5px;"><span style="margin-right:5px;">"Oh god" - <em>Kelsey</em>;</span><span>"C'mon, it's not that bad" - <em>Smith</em></span></div>`,
      },
    ],
  },
  [DIVISIVE_SORT]: {
    sortFunc: (a, b) => Math.abs(b.max - b.min) - Math.abs(a.max - a.min),
    description:
      'Apples sorted by the difference between the highest and lowest scores for each apple.',
    annotations: [
      {
        apple_type: 'McIntosh',
        annotation: `The <strong>McIntosh</strong> was our most divisive apple. Some loved the texture, while Carly had to spit it out.`,
      },
      {
        apple_type: 'Kanzi',
        annotation: `Everyone agreed - the <strong>Kanzi</strong> is a pretty good apple! All scores were between 3 and 4.`,
      },
    ],
  },
  [NAME_SORT]: {
    sortFunc: (a, b) => a.apple_type.localeCompare(b.apple_type),
    description: 'Apples sorted in alphabetical order by their names.',
    annotations: [
      {
        apple_type: 'Envy',
        annotation: `<span>Carly knows her <strong>Envy</strong> apple! Jeff tasted them everywhere.</span><p style="margin: 7px 0px;">"That's an envy" - <em>Carly on the Envy</em></p>"That's an envy" - <em>Jeff on the Envy, Sweetango, and Cosmic Crisp</em>`,
      },
      {
        apple_type: 'Ruby Frost',
        annotation: `<span>The <strong>Ruby Frost</strong> wasn't our most divisive apple, but it split some opinions.</span><p style="margin: 7px 0px;">"Oh hell yeah" - <em>Jeff</em></p>"Something's wrong" - <em>Carly</em>`,
      },
    ],
  },
};
