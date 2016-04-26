# README #

### Overview ###

* The GEM is the Ruby interface to the Oracle Public Cloud (OPC) Rest Interface.  If provide methods for OPC functionality including listing
creating, deleting, resizing, backups, and datagrid: Java Instances, Database instances, and storage.
This gem is the API other gems depend on this gem for connectivity

* Version 0.3.0

### Setup and Dependencies ###

* Requires Ruby gems, gem install OPC
* Configuration:
	 If a proxy server is required for connectivity the gem will look for a file opcclientcfg.conf in your home directory, the values in the file are proxy_addr = value  and proxy_port = value

* Dependencies
Ruby 1.8 or higher, RubyGems, Json, net/http
* How to run tests:
Install the oracle_public_cloud_client gem, which depends on this gem,  that gem will give you a command line interface into this gem and OPC

### Class and Method Descriptions ###

See CLASSES_README

### Repo Owner ###

* Daryn McCool 
* mdaryn@hotmail.com