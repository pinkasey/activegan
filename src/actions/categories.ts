import { Action } from '@ngrx/store';

export const ADD_CATEGORIES = 'ADD_CATEGORIES';
export const CLEAN_CATEGORIES = 'CLEAN_CATEGORIES';

export const addCategories = (payload): Action => ({
    type: ADD_CATEGORIES,
    payload
})

export const cleanCategories = (): Action => ({
    type: CLEAN_CATEGORIES
})