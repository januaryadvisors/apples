import { writable } from 'svelte/store';
import { POPULAR_SORT } from './helpers/tasteSort';

export const currentTasteSort = writable(POPULAR_SORT);
export const showAnnotations = writable(true);

export const currentRankFilter = writable('better')
