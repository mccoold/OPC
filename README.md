# README #

### Overview ###

* The GEM is the Ruby interface to the Oracle Public Cloud (OPC) Rest Interface.  If provide methods for OPC functionality including listing
creating, deleting, resizing, backups, and datagrid: Java Instances, Database instances, and storage.
This gem is the API other gems depend on this gem for connectivity

* Version 0.2.0

### Setup and Dependencies ###

* Requires Ruby gems, gem install <gem name>

* Configuration:
	 If a proxy server is required for connectivity the gem will look for a file opcclientcfg.conf in your home directory,t he values in the file are proxy_addr = value  and proxy_port = value

* Dependencies
Ruby 1.8 or higher, RubyGems, Json, net/http
* How to run tests:
Install the opc_client gem, which depends on this gem,  that gem will give you a command line interface into this gem and OPC

### Class and Method Descriptions ###

[CLASSES_README](https://github.com/mccoold/OPC/blob/master/CLASSES_README.md)

[RELEASE NOTES] (https://github.com/mccoold/OPC/wiki/RELEASE-NOTES-VERSION-0.2.0)

### Repo Owner ###

* Daryn McCool 
* mdaryn@hotmail.com
