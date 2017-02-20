import { ActionReducer, Action } from '@ngrx/store';
import { ADD_CATEGORIES, CLEAN_CATEGORIES } from '../actions';

export interface ICategoriesState {
    page: number;
    totalPages: number;
    totalItems: number;
    list: Array<any>
}

const defaultState = {
    page: 0,
    totalPages: undefined,
    totalItems: undefined,
    list: []
};

export const categoriesReducer: ActionReducer<Object> = (state: ICategoriesState = defaultState, action: Action) => {
    const payload = action.payload;

    switch (action.type) {
        case ADD_CATEGORIES: {
            const { totalPages, totalItems, list, page } = payload;
            const ids = list.map((post) => post.id);
            return Object.assign({}, state, {
                page,
                totalPages,
                totalItems,
                list: state.list.concat(ids)
            });
        }

        case CLEAN_CATEGORIES: {
            return defaultState;
        }

        default:
            return state;
    }
}