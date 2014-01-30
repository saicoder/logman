
logman.factory('$bucket',['$resource',function($resource){
	var Bucket = $resource('/api/buckets/:id',{id: '@id'},{
		save: {method: 'PUT'},
		create: {method: 'POST'},
		generateToken: {method: 'PUT', params:{generateToken:true}}
	}); 
	
	var collection = Bucket.query();
	
	return {
		Bucket: Bucket,
		collection: collection,
		reload: function(){
			Bucket.query({},function(ls){
				collection.length = 0;
				for (var i=0; i < ls.length; i++)collection.push(ls[i]); 
			});
		}
	}
}]);

var BucketListCtl = function($scope, $bucket, $location){
	$scope.buckets = $bucket.collection;
	$scope.is_admin = user.admin;
	
	$scope.toLogs = function(b){
		$location.path('/buckets/'+b.id+'/logs');
	}
	
	$scope.toDetails = function(b){
		$location.path('/buckets/'+b.id+'/details');
	}
}

var BucketAddEditCtl = function($scope, $bucket, $routeParams, $user,$location){
	$scope.users = $user.collection;
	
	if($routeParams.id)$scope.bucket= $bucket.Bucket.get({id: $routeParams.id})
	else $scope.bucket = new $bucket.Bucket({user_ids:[]});
	
	$scope.haveAccess = function(user){
		if(!$scope.bucket.user_ids)return;
		for (var i=0; i < $scope.bucket.user_ids.length; i++)
		  if($scope.bucket.user_ids[i]==user.id)return true;
		
		return false;
	}	
	
	$scope.invertAccess = function(user){
		if(!$scope.bucket.user_ids)return;
		var have = $scope.haveAccess(user);
		
		if(!have) $scope.bucket.user_ids.push(user.id);
		else $scope.bucket.user_ids.splice($scope.bucket.user_ids.indexOf(user.id),1);
	}
	
	$scope.saveCreate = function(){
		function success(){
			$bucket.reload();
		}
		
		if($scope.bucket.id)$scope.bucket.$save(success);
		else $scope.bucket.$create(success);	
	}
	
	$scope.generateToken = function(){
		message = "Warning!!!\n\nGenerating new token will cause all apps that use old token to stop! Continue?";
		if(confirm(message)){
			$scope.bucket.$generateToken($bucket.reload);
		}
	}
	
	$scope.destroyBucket = function(){
		if(confirm('Are you sure?')){
			$scope.bucket.$delete(function(){
				$bucket.reload();
				$location.path('/');
			});
		}
	}
}


var LogsCtl = function($scope, $resource, $routeParams,$bucket,$modal){
	$scope.bucket = $bucket.Bucket.get({id: $routeParams.id});
	
	$scope.loadLogs = function(page){
		// var page = ($scope.logs)? $scope.logs.page : 1;
		$scope.logs = $resource('/api/buckets/:bucket_id/logs').get({bucket_id: $routeParams.id, page: page});
	}
	
	
	$scope.show = function(log){
		$scope.active = log;
		var modalInstance = $modal.open({
	      templateUrl: '/app/bucket/log-details.html',
	      controller: LogDetails,
	      resolve: {log: function(){return log; }},
	      windowClass: 'full-modal'
	    });
	}
	
	$scope.loadLogs(1);
}


var LogDetails = function($scope, $modalInstance,log){
	 $scope.log = log;
	 
	 $scope.cancel = function () {
	    $modalInstance.dismiss('cancel');
	 };
	 
	 $scope.log_type = function(log,for_class_name){
	 	if(!for_class_name) return ['Error','Success','Warning', 'Info'][log.log_type-1]
	 	else{
	 		var klass = $scope.log_type(log).toLocaleLowerCase();
	 		if(klass=='error')klass='danger';
	 		return klass;
	 	} 
	 }
	 
	 $scope.formatData = function(root){
	 	return JSON.stringify(root);
	 }
}

logman.directive('jsonTree',function(){
	function link(scope, element){
		$(element).jsontree(scope.json_data);
	}
	
	return {
		link: link,
		scope: {json_data:'=jsonData'}
	}
});











