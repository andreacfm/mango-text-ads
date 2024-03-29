<!--- 
				
Project:     TextAds Mango Plugin http://www.andreacfm.com/page.cfm/open-source/text-ads-mango-plugin
Author:      Andrea Campolonghi <acampolonghi@gmail.com>
Version:     1.0
Build Date:  2009/08/09 15:38
Build:		 04

Copyright 2009 Andrea Campolonghi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
			 
--->
<cfcomponent output="false">

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getManager" access="public" output="false" returntype="any">
		<cfreturn variables.mainManager />
	</cffunction>

	<cffunction name="setManager" access="public" output="false" returntype="void">
		<cfargument name="mainManager" type="any" required="true" />
		<cfset variables.mainManager = arguments.mainManager />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getPreferencesManager" access="public" output="false" returntype="any">
		<cfreturn variables.preferencesManager />
	</cffunction>

	<cffunction name="setPreferencesManager" access="public" output="false" returntype="void">
		<cfargument name="preferencesManager" type="any" required="true" />
		<cfset variables.preferencesManager = arguments.preferencesManager />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getPackage" access="public" output="false" returntype="any">
		<cfreturn variables.package />
	</cffunction>
	
	<cffunction name="setPackage" access="public" output="false" returntype="void">
		<cfargument name="package" type="any" required="true" />
		<cfset variables.package = arguments.package />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="getSettingsPath" access="public" output="false" returntype="any">
		<cfreturn getManager().getBlog().getId() & "/" & getPackage() />
	</cffunction>

	<cffunction name="getAssetPath" access="public" output="false" returntype="any">
		<cfreturn getManager().getBlog().getBasePath() & "assets/plugins/" & getPluginDirName() & "/" />
	</cffunction>

	<cffunction name="getAdminAssetPath" access="public" output="false" returntype="any">
		<cfreturn getManager().getBlog().getBasePath() & "admin/assets/plugins/" & getPluginDirName() & "/" />
	</cffunction>
	
	<cffunction name="getPluginDirName" access="private" output="false" returntype="any">
		<cfset var name = getMetaData(this).name />
		<cfset var dir = ListGetAt(name, ListLen(name, ".")-1, ".")>
		<cfreturn dir />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->	
	<cffunction name="initSettings" access="public" output="true" returntype="void">
		<cfset var key = "" />
		<cfset variables.settings = StructNew() />
		<cfloop collection="#arguments#" item="key">
			<cfset variables.settings[key] = getPreferencesManager().get(getSettingsPath(), key, arguments[key]) />
		</cfloop>	
	</cffunction>
	
	<cffunction name="setSettings" access="public" output="false" returntype="void">
		<cfset var key = "" />
		<cfloop collection="#arguments#" item="key">
			<cfset variables.settings[key] = arguments[key] />
		</cfloop>
	</cffunction>
	
	<cffunction name="getSetting" access="public" output="false" returntype="any">
		<cfargument name="key" type="any" required="true" />
		<cfreturn variables.settings[arguments.key] />
	</cffunction>
	
	<cffunction name="persistSettings" access="public" output="false" returntype="void">
		<cfset var key = "" />
		<cfloop collection="#variables.settings#" item="key">
			<cfset getPreferencesManager().put(getSettingsPath(), key, variables.settings[key]) />
		</cfloop>
	</cffunction>

</cfcomponent>