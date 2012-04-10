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
<cfoutput>
<form method="post" action="#cgi.script_name#">

	<fieldset> 
		<legend>General Settings</legend> 
		<p>
			<label for="textAdsAll">Pod Title</label>
			<span class="hint">Title of the pod displaying the ads.</span>
			<span class="field"><input type="text" id="podTitle" name="podTitle" value="#getSetting('podTitle')#" size="100" class="required"/></span>
		</p>
	
		<p>
			<label for="errorMessage">Error Message:</label>
			<span class="hint">Message to be shown in case of failure in reading xml data or any other error during data process.</span>
			<span class="field"><input type="text" id="errorMessage" name="errorMessage" value="#getSetting('errorMessage')#" size="100" class="required"/></span>
		</p>
	</fieldset>
	
	<fieldset> 
		<legend>TEXT-LINK-ADS ( http://www.text-link-ads.com )</legend> 
		<p>
			<label for="textAdsAll">Text-Links-Ads Code</label>
			<span class="hint">This is the code that Text-Link-Ads gave you on accepting your blog submission ( plugin only support one key for the whole site. Single page ads is not supported yet.)</span>
			<span class="field"><input type="text" id="textAdsAll" name="textAdsAll" value="#getSetting('textAdsAll')#" size="30" class="required"/></span>
		</p>	
	</fieldset>
	
	<p class="actions">
		<input type="submit" class="primaryAction" value="Submit"/>
		<input type="hidden" value="event" name="action" />
		<input type="hidden" value="showTextAdsSettings" name="event" />
		<input type="hidden" value="true" name="apply" />
	</p>

</form>
</cfoutput>