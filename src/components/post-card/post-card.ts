import { NavController } from 'ionic-angular';
import { Component, Input } from '@angular/core';

import { PostPage } from '../../pages/post/post';
/*
  Generated class for the PostCard component.

  See https://angular.io/docs/ts/latest/api/core/index/ComponentMetadata-class.html
  for more info on Angular 2 Components.
*/
@Component({
  selector: 'post-card',
  templateUrl: 'post-card.html'
})
export class PostCardComponent {
  @Input() post: any;
  categories: Array<any>;
  tags: Array<any>;

  constructor(
    public navCtrl: NavController
  ) { }

  ngOnInit() {
    const terms = this.post._embedded['https://api.w.org/term'] || this.post._embedded['wp:term'];
    this.categories = terms[0];
    this.tags = terms[1];
  }

  doOpen(e) {
    this.navCtrl.push(PostPage, {
      id: this.post.id
    })
  }

}