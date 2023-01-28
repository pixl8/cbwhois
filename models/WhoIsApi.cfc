component singleton=true accessors=true {

	property name="defaultApiKey"   inject="coldbox:setting:defaultApiKey@cbwhois"   default="";
	property name="defaultFields"   inject="coldbox:setting:defaultFields@cbwhois"   default="";
	property name="defaultLanguage" inject="coldbox:setting:defaultLanguage@cbwhois" default="";
	property name="defaultTimeout"  inject="coldbox:setting:defaultTimeout@cbwhois"  default=2;
	property name="defaultReferer"  inject="coldbox:setting:defaultReferer@cbwhois"  default="";

	public struct function lookup(
		  required string  ipAddress
		,          string  apiKey           = defaultApiKey
		,          string  fields           = defaultFields
		,          string  lang             = defaultLanguage
		,          string  referer          = defaultReferer
		,          numeric timeout          = defaultTimeout
		,          boolean getSecurityInfo  = false
		,          boolean getRateUsageInfo = false
	) {
		return _call(
			  argumentCollection = arguments
			, path               = "/#arguments.ipAddress#"
		);
	}

	public array function bulkLookup(
		  required array   ipAddresses
		,          string  apiKey           = defaultApiKey
		,          string  fields           = defaultFields
		,          string  lang             = defaultLanguage
		,          string  referer          = defaultReferer
		,          numeric timeout          = defaultTimeout
		,          boolean getSecurityInfo  = false
		,          boolean getRateUsageInfo = false
	) {
		return _call(
			  argumentCollection = arguments
			, path               = "/bulk"
			, jsonBody           = arguments.ipAddresses
		);
	}

// PRIVATE HELPERS
	private any function _call(
		  required string  path
		,          string  apiKey           = ""
		,          string  fields           = ""
		,          string  lang             = ""
		,          numeric timeout          = 2
		,          string  referer          = ""
		,          boolean getSecurityInfo  = false
		,          boolean getRateUsageInfo = false
		,          any     jsonBody

	) {
		var result = "";

		http url="https://#_getApiDomain( arguments.apiKey )##arguments.path#" timeout=arguments.timeout throwonerror=true result="result" {
			if ( Len( arguments.apiKey ) ) {
				httpparam name="key" type="url" value=arguments.apiKey;
			}
			if ( Len( arguments.fields ) ) {
				httpparam name="fields" type="url" value=arguments.fields;
			}
			if ( Len( arguments.lang ) ) {
				httpparam name="lang" type="url" value=arguments.lang;
			}
			if ( arguments.getSecurityInfo ) {
				httpparam name="security" type="url" value="1";
			}
			if ( arguments.getRateUsageInfo ) {
				httpparam name="rate" type="url" value="1";
			}
			if ( StructKeyExists( arguments, "referer" ) ) {
				httpparam type="header" name="Referer" value=arguments.referer;
			}

			if ( StructKeyExists( arguments, "jsonBody" ) ) {
				httpparam type="header" name="Content-Type" value="application/json";
				httpparam type="body" value=SerializeJson( arguments.jsonBody );
			}
		}

		return DeserializeJson( result.fileContent );
	}

	private string function _getApiDomain( apiKey ) {
		if ( Len( arguments.apiKey ) ) {
			return "ipwhois.pro";
		}

		return "ipwho.is";
	}

}