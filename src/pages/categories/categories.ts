import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { WpApiTerms } from 'wp-api-angular'
import { Observable } from 'rxjs';
import { Store } from '@ngrx/store';

import { addCategories, cleanCategories } from '../../actions';
import { AppState, ICategoryState } from '../../reducers';
import {ICategoriesState} from "../../reducers/categories";
import {addCategories} from "../../actions/categories";

/*
 Generated class for the Posts page.

 See http://ionicframework.com/docs/v2/components/#navigation for more info on
 Ionic pages and navigation.
 */
@Component({
  selector: 'page-categories',
  templateUrl: 'categories.html'
})
export class CategoriesPage {

  isPaginationEnabled: boolean = true;
  shouldRetry: boolean = false;
  page: number = 1;
  categories$: Observable<Array<any>>;

  constructor(
      public navCtrl: NavController,
      public navParams: NavParams,
      private wpApiTerms: WpApiTerms,
      private store: Store<AppState>
  ) {
    this.categories$ = store.select('categories')
        .combineLatest(this.store.select('categories'), (categories: ICategoriesState, category) => categories.list.map(id => category[id]));
  }

  ionViewDidLoad() {
    let currentList;
    this.store.select('categories').take(1).subscribe(({ list }) => currentList = list);
    console.log('ionViewDidLoad CategoriesPage', currentList);
    if (!currentList.length) {
      this.getPosts().toPromise();
    }
  }

  trackByCategoryId = (index: number, item) => item.id;

  private getCategories() {
    console.log('getCategories');
    let currentPage;
    this.store.select('categories').take(1).subscribe(({ page }) => currentPage = page);
    const nextPage = currentPage += 1;

    return this.wpApiTerms.getList({
      "search": `_embed=true&per_page=10&page=${nextPage}`
    })
        .debounceTime(400)
        .retry(3)
        .map((r) => {
          const totalPages = parseInt(r.headers.get('x-wp-totalpages'));
          this.store.dispatch(addCategories({
            page: nextPage,
            totalPages,
            totalItems: parseInt(r.headers.get('x-wp-total')),
            list: r.json()
          }));
          this.isPaginationEnabled = true;
          return totalPages <= nextPage;
        })
        .catch(res => {
          this.shouldRetry = true;
          this.isPaginationEnabled = false;
          console.log("ERROR! " + res);
          return res;
        });
  }

  doLoad() {
    console.log('doLoad');
    return this.getCategories().toPromise();
  }

  doRefresh(refresher) {
    console.log('doRefresh');
    this.store.dispatch(cleanCategories());
    this.getCategories().toPromise().then(() => refresher.complete(), (error) => refresher.complete());
  }

  doInfinite(infiniteScroll) {
    console.log('doInfinite');
    this.getCategories().toPromise().then((isComplete) => {
      infiniteScroll.complete();
      this.isPaginationEnabled = !isComplete;
    }, (error) => infiniteScroll.complete());
  }

}
