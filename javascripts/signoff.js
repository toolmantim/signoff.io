(function() {
  "use strict";

  var app = angular.module('Signoff', []);

  app.factory('LinkList', function($http) {
    var LinkList = {};

    LinkList.all = $http.get('json/links.json').then(function(response) { return response.data; });
    LinkList.current = LinkList.all.then(function(days){ return days[0].links[0]; });

    return LinkList;
  });

  app.run(function($rootScope, LinkList) {
    $rootScope.list = LinkList;
  });

  app.filter('withoutUrl', function() {
    return function(input, url) {
      return input.replace(url, '★');
    };
  });

  app.controller('AppCtrl', function() {
  });

  app.controller('LinkListCtrl', function() {
  });

  app.controller('LinkDetailCtrl', function($scope, $element, $timeout) {
    // Init and reset the twitter cards on any change
    $scope.$watch('list.current', function() {
      $element.find('iframe').remove();
      $timeout(function() {
        if (window.twttr)
          twttr.widgets.load();
      }, 0);
    });
  });

})();
