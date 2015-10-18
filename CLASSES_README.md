# Class and Method Descriptions #
Classes are broken up into 3 folders DBaaS JaaS and IaaS.  All of these methods have little error handling, they pass the REST error 
message, more robust error handling is done at the client level, either opc_client or knife-opc (gems that leverage this gem)


All classes will require the userid, passwd, and id_domain to be sent as paremters, methods will only take what they specifically need.

## JaaS ##

* jassmanager: mngstate stops/starts and instace; scale_up increases the size of the Weblogic Cluster; scale_in decreases the size of the
WebLogic cluster or add block storage
* backupmanager: does stuff with backups

## DBaaS ##

* dbdelete:  one method, delete, resturns JSON as a response
* dbassManager: mngstate stops/starts and instace; scale_up changes the shape of the DB or add block storage
* datagrid: used to create and manage coherience instances, still in beta

## IaaS ##

For the IaaS services, except object storage, there is a concept of administration/config containers where configuration objects or stored.  
Containers always start with a "/" the base container for all of your objects is "/Compute-your id domain/"
for all of these methods the REST endpoint will be different for each account so it needs to be passed into the method

* secapplication_discover:  Used to list security applications in a container or get details on specific objects
* secapplication_list: about the same as discover details
* secapplication_modify: used to create delete applications, function determined by action parameter
	* secapplication_modify(restendpoint, action, id_domain, user, passwd, *data)
* secrule_list: about the same as discover details 

## PaaS ##
functions that are the same across the various PaaS platforms:
* srvlist: inst_list displays details on an instance; service_list  lists all instances for an account
* instcreate: creates a new java instance, can be used for stand alone or managed servers, it has two methods, create, and create status.
 		* create requires a Hash to be passed which is converted to JSON
 		* Both return a hash formatted for JSON as a result, this is used for both jcs and dbcs
 * instdelete: one method, delete, resturns JSON as a response

## Object Storage ##
 * create:  takes one parameter <container name> and creates new containers
 * list:  list containers
 * contents:  list the contents of a conainer
 * delete: deletes containers
 * object_create: uploads objects to containers
 * 
 ## Block Storage 


