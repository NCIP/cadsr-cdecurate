// AngularJS Stuff
var myApp = angular.module('app', [], ctrlRead);

function ctrlRead($scope, $filter) {
    // app specific init
    //$scope.title = "Custom Profile";
    $scope.createLinkTitle = "New Profile";
    $scope.header1 = "Action";
    $scope.header2 = "ID";
    $scope.header3 = "Name";
    $scope.header4 = "Description";
    $scope.enterNew = true;
    // common init
    $scope.sortingOrder = sortingOrder;
    $scope.reverse = false;
    $scope.filteredItems = [];
    $scope.groupedItems = [];
    $scope.itemsPerPage = 5;
    $scope.pagedItems = [];
    $scope.currentPage = 0;
    $scope.items = [
        {"id":"1","name":"name 1","description":"description 1","createDate":"","field4":"field4 1","field5 ":"field5 1"},
        {"id":"2","name":"name 2","description":"description 2","createDate":"field3 2","field4":"field4 2","field5 ":"field5 2"},
        {"id":"3","name":"name 3","description":"description 3","createDate":"field3 3","field4":"field4 3","field5 ":"field5 3"},
        {"id":"4","name":"name 4","description":"description 4","createDate":"field3 4","field4":"field4 4","field5 ":"field5 4"},
        {"id":"5","name":"name 5","description":"description 5","createDate":"field3 5","field4":"field4 5","field5 ":"field5 5"},
        {"id":"6","name":"name 6","description":"description 6","createDate":"field3 6","field4":"field4 6","field5 ":"field5 6"},
        {"id":"7","name":"name 7","description":"description 7","createDate":"field3 7","field4":"field4 7","field5 ":"field5 7"},
        {"id":"8","name":"name 8","description":"description 8","createDate":"field3 8","field4":"field4 8","field5 ":"field5 8"},
        {"id":"9","name":"name 9","description":"description 9","createDate":"field3 9","field4":"field4 9","field5 ":"field5 9"},
        {"id":"10","name":"name 10","description":"description 10","createDate":"field3 10","field4":"field4 10","field5 ":"field5 10"},
        {"id":"11","name":"name 11","description":"description 11","createDate":"field3 11","field4":"field4 11","field5 ":"field5 11"},
        {"id":"12","name":"name 12","description":"description 12","createDate":"field3 12","field4":"field4 12","field5 ":"field5 12"},
        {"id":"13","name":"name 13","description":"description 13","createDate":"field3 13","field4":"field4 13","field5 ":"field5 13"},
        {"id":"14","name":"name 14","description":"description 14","createDate":"field3 14","field4":"field4 14","field5 ":"field5 14"},
        {"id":"15","name":"name 15","description":"description 15","createDate":"field3 15","field4":"field4 15","field5 ":"field5 15"},
        {"id":"16","name":"name 16","description":"description 16","createDate":"field3 16","field4":"field4 16","field5 ":"field5 16"},
        {"id":"17","name":"name 17","description":"description 17","createDate":"field3 17","field4":"field4 17","field5 ":"field5 17"},
        {"id":"18","name":"name 18","description":"description 18","createDate":"field3 18","field4":"field4 18","field5 ":"field5 18"},
        {"id":"19","name":"name 19","description":"description 19","createDate":"field3 19","field4":"field4 19","field5 ":"field5 19"},
        {"id":"20","name":"name 20","description":"description 20","createDate":"field3 20","field4":"field4 20","field5 ":"field5 20"}
    ];

    var searchMatch = function (haystack, needle) {
        if (!needle) {
            return true;
        }
        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
    };

    // init the filtered items
    $scope.search = function () {
        $scope.filteredItems = $filter('filter')($scope.items, function (item) {
            for(var attr in item) {
                if (searchMatch(item[attr], $scope.query))
                    return true;
            }
            return false;
        });
        // take care of the sorting order
        if ($scope.sortingOrder !== '') {
            $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
        }
        $scope.currentPage = 0;
        // now group by pages
        $scope.groupToPages();
    };

    // calculate page in place
    $scope.groupToPages = function () {
        $scope.pagedItems = [];

        for (var i = 0; i < $scope.filteredItems.length; i++) {
            if (i % $scope.itemsPerPage === 0) {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [ $scope.filteredItems[i] ];
            } else {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
            }
        }
    };

    $scope.range = function (start, end) {
        var ret = [];
        if (!end) {
            end = start;
            start = 0;
        }
        for (var i = start; i < end; i++) {
            ret.push(i);
        }
        return ret;
    };

    $scope.prevPage = function () {
        if ($scope.currentPage > 0) {
            $scope.currentPage--;
        }
    };

    $scope.nextPage = function () {
        if ($scope.currentPage < $scope.pagedItems.length - 1) {
            $scope.currentPage++;
        }
    };

    $scope.setPage = function () {
        $scope.currentPage = this.n;
    };

    // functions have been describe process the data for display
    $scope.search();

    // change sorting order
    $scope.sort_by = function(newSortingOrder) {
        if ($scope.sortingOrder == newSortingOrder)
            $scope.reverse = !$scope.reverse;

        $scope.sortingOrder = newSortingOrder;

        // icon setup
        $('th i').each(function(){
            // icon reset
            $(this).removeClass().addClass('icon-sort');
        });
        if ($scope.reverse)
            $('th.'+new_sorting_order+' i').removeClass().addClass('icon-chevron-up');
        else
            $('th.'+new_sorting_order+' i').removeClass().addClass('icon-chevron-down');
    };

    $scope.newItem = function() {
        $scope.enterNew = true;
        $scope.editing = false;
        $scope.copying = false;
        $scope.item = {};
    };

    $scope.createItem = function() {
        $scope.item.createdDate = new Date();
        $scope.pagedItems[$scope.currentPage].push($scope.item);
        //$scope.items.push($scope.item);

        /*
         $http.post('/students.json', {"student": $scope.student})
         .success(function(response, status, headers, config){
         $scope.students.push(response.student);
         $scope.enterNew = false;
         $scope.editing = false;
         })
         .error(function(response, status, headers, config){
         $scope.error_message = response.error_message;
         });
         */

        $scope.enterNew = true;
        $scope.editing = false;
        $scope.copying = false;
        $scope.item = "";
        //$scope.groupToPages();
    }

    $scope.cancelSave = function() {
        $scope.enterNew = true;
        $scope.editing = false;
        $scope.copying = false;
        $scope.item = {};
    };

    $scope.editItem = function(item) {
        $scope.enterNew = false;
        $scope.editing = true;
        $scope.copying = false;
        $scope.item = item;
    };

    $scope.copyItem = function(item) {
        $scope.enterNew = false;
        $scope.editing = false;
        $scope.copying = true;
        
        newItem = {};
        newItem.name = item.name;
        newItem.description = item.description;
        newItem.createDate = new Date();
        
        $scope.newItem = newItem;
        $scope.item = newItem;
    };

    $scope.cloneItem = function(item) {
        $scope.pagedItems[$scope.currentPage].push($scope.newItem);
        
        $scope.enterNew = true;
        $scope.editing = false;
        $scope.copying = false;
        
        $scope.item = "";
    };

    $scope.updateItem = function() {
        $scope.item.createdDate = new Date();

/*
        $http.put('/students/' + $scope.student.id + '.json', {"student": $scope.student})
            .success(function(response, status, headers, config){
                $scope.student = response.student;
                $scope.enterNew = false;
                $scope.editing = false;
            })
            .error(function(response, status, headers, config){
                $scope.error_message = response.error_message;
            });
*/
        $scope.enterNew = true;
        $scope.editing = false;
        $scope.copying = false;
        $scope.item = "";
    };

    $scope.deleteItem = function(item) {
        var index = $scope.pagedItems[$scope.currentPage].indexOf(item);
        $scope.pagedItems[$scope.currentPage].splice(index,1);
        var index2 = $scope.items.indexOf(item);
        $scope.items.splice(index2,1);
        /*
         $http.delete('/students/' + student.id + '.json')
         .success(function(response, status, headers, config){
         var index = $scope.students.indexOf(student);
         $scope.students.splice(index,1);
         })
         .error(function(response, status, headers, config){
         $scope.error_message = response.error_message;
         });
         */
//        loadItems();
    }

};

ctrlRead.$inject = ['$scope', '$filter'];

