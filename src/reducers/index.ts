import { postReducer } from './post';
import { bookmarksReducer } from './bookmarks';
import { postsReducer, IPostsState } from './posts';
import { categoriesReducer, ICategoriesState } from './categories';

export * from './post';
export * from './posts';
export * from './bookmarks';
export * from './categories';

export interface AppState {
    post: Object;
    posts: IPostsState;
    bookmarks: Array<String>
}

export default {
    post: postReducer,
    posts: postsReducer,
    bookmarks: bookmarksReducer
}