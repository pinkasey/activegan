module.exports = angular.module('wordpress-hybrid-client.posts').factory '$WPHCPosts', ($log, $wpApiPosts, $q, $WPHCConfig, DSCacheFactory) ->
    $log.info '$WPHCPosts'

    getCache = () ->
        if DSCacheFactory.get 'posts'
            return DSCacheFactory.get 'posts'
        DSCacheFactory 'posts', $WPHCConfig.posts.cache

    getQuery: (page) ->
        page: page
        "filter[posts_per_page]": $WPHCConfig.posts.posts_per_page
        "filter[orderby]": $WPHCConfig.posts.orderby
        "filter[order]": $WPHCConfig.posts.order
        "filter[post_status]": $WPHCConfig.posts.post_status

    getList: (query) ->
        queryString = JSON.stringify query
        deferred = $q.defer()
        listCache = getCache().get 'list-' + queryString
        $log.debug listCache, 'Post cache'
        if listCache
            deferred.resolve listCache
        else
            $wpApiPosts.$getList query
            .then (response) ->
                response.isPaginationOver = (response.data.length is 0 or response.data.length < $WPHCConfig.posts.posts_per_page)
                getCache().put 'list-' + queryString, response
                deferred.resolve response
        deferred.promise