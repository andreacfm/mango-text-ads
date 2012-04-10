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
<cfcomponent extends="BasePlugin"> 
 
    <cffunction name="init" access="public" output="false" returntype="any"> 
        <cfargument name="mainManager" type="any" required="true" /> 
        <cfargument name="preferences" type="any" required="true" /> 
         
        <cfset setManager(arguments.mainManager) /> 
        <cfset setPreferencesManager(arguments.preferences) /> 
        <cfset setPackage("com/andreacfm/mango/plugins/textads") />
		
		<cfset initSettings(textAdsAll = "",errorMessage='Network connenction failure!',podTitle = 'Interesting Links') />
			                    
        <cfreturn this/> 
    
	</cffunction> 
 
    <cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any"> 
        <cfreturn "Plugin activated." /> 
    </cffunction> 
     
    <cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any"> 
        <cfreturn /> 
    </cffunction> 
 
    <cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any"> 
        <cfargument name="event" type="any" required="true" />         
        <cfreturn /> 
    </cffunction> 
 
    <cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any"> 
        <cfargument name="event" type="any" required="true" /> 
		
		<cfset var ev = arguments.event />
		<cfset var eventname = ev.name />
		<cfset var prefManager = getPreferencesManager() />
		<cfset var data = arguments.event.getData() />
		
		<cfswitch expression="#eventname#">
			
			<cfcase value="settingsNav">

				<cfset link = structnew() />
				<cfset link.owner = "textAds">
				<cfset link.page = "settings" />
				<cfset link.title = "Text Ads Link" />
				<cfset link.eventName = "showTextAdsSettings" />
				<cfset ev.addLink(link) />
			
			</cfcase>
			
			<cfcase value="showTextAdsSettings">
				
				<cfif structkeyexists(data.externaldata,"apply")>					
					<cfset variables.settings.textAdsAll = data.externaldata.textAdsAll />
					<cfset variables.settings.errorMessage = data.externaldata.errorMessage />
					<cfset variables.settings.podTitle = data.externaldata.podTitle />
					<cfset persistSettings()/>
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("Configurations Updated")/>
				</cfif>
				<cfsavecontent variable="page">
					<cfinclude template="#getAdminAssetPath()#/settingsForm.cfm">
				</cfsavecontent>
				<cfset data.message.setTitle("Text Ads Settings") />
				<cfset data.message.setData(page) />
			</cfcase>
			
			<cfcase value="getPodsList">
				<cfset pod = structnew() />
				<cfset pod.title = "Text Ads">
				<cfset pod.id = "text-ads" />
				<cfset ev.addPod(pod) />
			</cfcase>
			
			<cfcase value="getPods">

				<cfif event.allowedPodIds EQ "*" OR listfindnocase(event.allowedPodIds, "text-ads")>
					
					<cfsavecontent variable="page">
						<cfoutput>
							#getTextLinkAds(getsetting('textAdsAll'))#
						</cfoutput>
					</cfsavecontent>
					
					<cfset pod = structnew() />
					<cfset pod.title = getSetting('podTitle') />
					<cfset pod.content = page />
					<cfset pod.id = "text-ads" />
					<cfset ev.addPod(pod) />
					
				</cfif>

			</cfcase>

		</cfswitch>
		
        <cfreturn arguments.event /> 
    </cffunction> 
	
	<cffunction name="getTextLinkAds" access="private" hint="Raed the link from xml or refresh from textadslink repository">
		<cfargument name="textLinkAdsKey" required="true" type="string"/>
	
		<cfset var key = arguments.textLinkAdsKey />
		<cfset var filename = key & '.cfm' />
		<cfset var dir = expandPath(getAssetPath() & '/text-link-ads/') />
		<cfset var filepath = dir & filename />
		<cfset var localfile = "" />
		<cfset var localfiledetails = "" />
		<cfset var remotefile = "" />
		<cfset var xml = "" />
		<cfset var items = "" />
		<cfset var result = "" />
		
		<cftry>  		

			<!---check for directory - if no exist create one empty--->
			<cfif not directoryExists(dir)>
				<cfdirectory action="create" directory="#dir#" />
			</cfif>
					
			<!---check for file - if no exist create one empty--->
			<cfif not fileExists(filepath)>
				<cffile action="write"  file="#filepath#" output="" /> 
			</cfif>
		
			<!--- read the file --->
			<cffile action="read" file="#filepath#" variable="localfile" />
		
			<!--- get info about the file  --->
			<cfdirectory action="list" directory="#dir#" filter="#filename#" name="localfiledetails" />
			
			<!--- if necessary pull the results from server--->
			<cfif (len(localfile) lte 20) or (datecompare(localfiledetails.datelastmodified, dateadd("h", -1, now())) eq -1)>
				<cfhttp url="http://www.text-link-ads.com/xml.php?inventory_key=#key#" method="get" timeout="3" />
				<cfset remotefile = cfhttp.filecontent />
				<cfif len(remotefile) lte 20>
					<cfset remoteFile = localFile />
				<cfelse>
					<cffile action = "write" file = "#filepath#" output = "#remotefile#" />
					<cfset localfile = remotefile />
				</cfif>	
			</cfif>
		
			<cfif isXml(localfile)>
		  		<cfset xml = xmlparse(localfile) />		
				<cfset items = xml.links.xmlchildren />
			<cfelse>
				<cfset items = arraynew(1) />
			</cfif>		
			
			<cfif arraylen(items) gte 1>
				<cfsavecontent variable="result">
					<cfoutput>
						<ul class="list-blogroll">
						<cfloop from="1" to="#arraylen(items)#" index="i">
							<li>#items[i].beforetext.xmltext# <a target="_blank" href="#items[i].url.xmltext#">#items[i].text.xmltext#</a> #items[i].aftertext.xmltext#</li>									
						</cfloop>
						</ul>
					</cfoutput>		
				</cfsavecontent>	
			</cfif>
			<cfcatch type="any">
				<cfrethrow />
				<cfset result = getSetting('errorMessage') />
			</cfcatch>
		</cftry>
		
		<cfreturn result/>
	
	</cffunction>
 
</cfcomponent>