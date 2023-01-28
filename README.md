# Who.is IP Lookup API

_For CFML Application with Coldbox bindings_

## Summary

This project provides CFML applications with a **lightweight** abstraction of the who.is IP lookup service: [https://ipwhois.io/](https://ipwhois.io/). Lightweight means:

* **No caching** _your application can and should take care of caching results_
* **No error handling** _your application should handle any unexpected errors from the http call to the api. I'm lazy and this utility does the bare minimum_

**A note on free vs paid-for account:** you can use the API without an API key for "free" usage which includes 10,000 IP lookups per-month as of January 2023 - based on source IP and http referrer. Certain features are not available with the free tier and commercial usage is also not allowed. See the website for further details: [https://ipwhois.io/](https://ipwhois.io/).

## Installation

For coldbox applications, install as a module with `box install cbwhois`. For anything else, manually download from the [releases](https://github.com/pixl8/cbwhois/releases) page and unzip somewhere sensible in your project.

## Using the API wrapper

Usage can be summarized as:

1. Get an instance of the CFC
2. Optionally set defaults
3. Make calls using the `lookup( ipAddress )` and `bulkLookup( ipAddresses, apiKey )` methods

### 1. Get an instance

#### For Coldbox applications

Inject as a dependency with: `inject="whoisApi@cbwhois`. For example:

```cfc
property name="whoIsApi" inject="whoisApi@cbwhois";

// ...

var result = whoIsApi.lookup( ipAddress );
```

#### For non-Coldbox applications

Get an instance of the component by instantiating the `/models/WhoIsApi.cfc` component:

```cfc
// assumes you have the code in a /cbwhois directory
// in your project. Adjust the example given your own
// installation choice:
var whoIsApi = new cbwhois.models.WhoIsApi();

// ...

var result = whoIsApi.lookup( ipAddress );
```

### Configure defaults

#### For Coldbox applications

In your Coldbox application's config file, you can set the following module settings to set defaults:

```cfc
moduleSettings.cbwhois.defaultApiKey   = "your-api-key"; // recommend to inject using environment variables
moduleSettings.cbwhois.defaultFields   = ""; // if empty, all fields are returned by default
moduleSettings.cbwhois.defaultLanguage = ""; // if empty, en is used as default
moduleSettings.cbwhois.defaultTimeout  = 1; // seconds
moduleSettings.cbwhois.defaultReferer  = ""; // potentially useful to segment your usage stats - use a different referer per application
```

#### For non-Coldbox applications

Once you have an instance, you may optionally set defaults using setter methods on the instance:

```cfc
// assumes you have the code in a /cbwhois directory
// in your project. Adjust the example given your own
// installation choice:
var whoIsApi = new cbwhois.models.WhoIsApi();

whoIsApi.setDefaultApiKey( "your-api-key" ); // recommend to inject using environment variables
whoIsApi.setDefaultFields( "" );             // if empty, all fields are returned by default
whoIsApi.setDefaultLanguage( "" );           // if empty, en is used as default
whoIsApi.setDefaultTimeout( 1 );             // seconds
whoIsApi.setDefaultReferer( "" );            // potentially useful to segment your usage stats - use a different referer per application

// ...

var result = whoIsApi.lookup( ipAddress );
```

### Calling the API methods

There are two methods, lookup() and bulkLookup(). Bulk lookup _requires_ an API key. Usage arguments are illustrated here:


#### lookup( ipAddress )

```cfc
// bare minimum, uses defaults for all other arguments
var result = whoIsApi.lookup( ipAddress );

// all arguments manually set, overriding any defaults
var result = whoIsApi.lookup(
	  ipAddress        = ipAddress
	, apiKey           = apiKey
	, fields           = "region,security,rate"
	, lang             = "de"
	, referer          = "my-app"
	, timeout          = 10 // seconds
	, getSecurityInfo  = true // only available at certain whois api account levels, api key required
	, getRateUsageInfo = true // only available at certain whois api account levels, api key required
);
```

#### bulkLookup( ipAddresses )

```cfc
// bare minimum, uses defaults for all other arguments
var result = whoIsApi.bulkLookup( [ ipAddressOne, ipAddressTwo, ipAddressThree ] );

// all arguments manually set, overriding any defaults
var result = whoIsApi.bulkLookup(
	  ipAddresses      = [ ipAddressOne, ipAddressTwo, ipAddressThree ]
	, apiKey           = apiKey
	, fields           = "region,security,rate"
	, lang             = "de"
	, referer          = "my-app"
	, timeout          = 10 // seconds
	, getSecurityInfo  = true // only available at certain whois api account levels, api key required
	, getRateUsageInfo = true // only available at certain whois api account levels, api key required
);
```

## Versioning

We use [SemVer](https://semver.org) for versioning. For the versions available, see the [tags on this repository](https://github.com/pixl8/cbwhois/releases). Project releases can also be found and installed from [Forgebox](https://forgebox.io/view/cbwhois)

## License

This project is licensed under the GPLv2 License - see the [LICENSE.txt](https://github.com/pixl8/cbwhois/blob/stable/LICENSE.txt) file for details.

## Authors

The project is maintained by [The Pixl8 Group](https://www.pixl8.co.uk). The lead developer is [Dominic Watson](https://github.com/DominicWatson).

## Code of conduct

We are a small, friendly and professional community. For the eradication of doubt, we publish a simple [code of conduct](https://github.com/pixl8/cbwhois/blob/stable/CODE_OF_CONDUCT.md) and expect all contributors, users and passers-by to observe it.