## Class and Method Descriptions ##
Classes are broken up into 3 folders DBaaS JaaS and IaaS.  All of these methods have little error handling, they pass the REST error 
message, more robust error handling is done at the client level, either opc_client or knife-opc (gems that leverage this gem)

** JaaS **

* instcreate: creates a new java instance, can be used for stand alone or managed servers, it has two methods, create, and create status.
 Both return a hash formatted for JSON as a result 
* instdelete:  one method, delete, resturns JSON as a response
* jassManager: mngstate stops/starts and instace; scale_up increases the size of the Weblogic Cluster; scale_in decreases the size of the
WebLogic cluster
* srvlist: inst_list displays details on an instance; service_list  lists all instances for an account
* backupmanager: does stuff with backups

**DBaaS**

* dbcreate: creates a new DB instance,  it has two methods, create, and create status.
	* create requires a Hash to be passed which is converted to JSON
 Both return a hash formatted for JSON as a result 
* dbdelete:  one method, delete, resturns JSON as a response
* dbassManager: mngstate stops/starts and instace; scale_up changes the shape of the DB
* dbservicelist: inst_list displays details on an instance; service_list  lists all instances for an account

**IaaS**

* Storage
