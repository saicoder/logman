logman.factory('$user',['$resource',function($resource){
	var User = $resource('/api/users/:id',{id:'@id'},{
		save:{method:'PUT'},
		create:{method:'POST'}
	});
	var collection = User.query();
	
	return{
		Class: User,
		collection: collection,
		reload: function(){
			User.query({},function(ls){
				collection.length = 0;
				for (var i=0; i < ls.length; i++)collection.push(ls[i]); 
			});
		},
		byId: function(id){
			for (var i=0; i < this.collection.length; i++) {
			 if(this.collection[i].id == id) return this.collection[i];
			};	
		}
	}
}]);

var UsersListCtl = function($scope, $user, $modal){
	$scope.users = $user.collection;
	$scope.is_admin = user.admin;
	
	$scope.remove = function(user){
		if(confirm('Are you sure?')){
			user.$delete($user.reload);
		}
	}
	
	$scope.addEdit = function(user){

		var modalInstance = $modal.open({
	      templateUrl: '/app/user/user-modal.html',
	      controller: UserModalCtl,
	      resolve: {active_user: function(){return user; }}
	    });
	}
	
	$scope.userProfile = function(){
		var me = $user.Class.get({id: window.user.id});
		$scope.addEdit(me);
	}
}

var UserModalCtl = function($scope, $modalInstance, $user, active_user){
	 $scope.user = active_user;
	 if(!$scope.user)$scope.user = new $user.Class();
	 $scope.is_admin = window.user.admin;
	 
	 $scope.addEdit = function(){
	 	function success(){
	 		$user.reload();
	 		$modalInstance.dismiss();
	 	}
	 	
	 	if($scope.user.id)$scope.user.$save(success);
	 	else $scope.user.$create(success)
	 }
	 
	 	
	 $scope.cancel = function () {
	    $modalInstance.dismiss('cancel');
	  };
}
