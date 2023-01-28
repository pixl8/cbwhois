component extends="testbox.system.BaseSpec" {

	function run(){
		var env                     = CreateObject("java", "java.lang.System").getenv();
		var apiKey                  = Trim( env.WHOIS_TEST_API_KEY ?: "" );
		var randomlyPickedIp        = "134.18.210.110";
		var anotherRandomlyPickedIp = "210.5.3.100";

		describe( "lookup( ipAddress )", function(){

			it( "should use free endpoint to get default info from who.is lookup with no api key or other arguments", function(){
				var result = new cbwhois.models.WhoIsApi().lookup(
					ipAddress = randomlyPickedIp
				);

				expect( result.success ).toBe( true );
				expect( result.type ).toBe( "IPv4" );
				expect( result.continent ).toBe( "Oceania" );
				// etc.
			} );

			it( "should limit returned fields when told to", function(){
				var result = new cbwhois.models.WhoIsApi().lookup(
					  ipAddress = randomlyPickedIp
					, fields    = "region"
				);

				expect( StructKeyList( result ) ).toBe( "region" );
			} );

			it( "should use localisation when told to", function(){
				var result = new cbwhois.models.WhoIsApi().lookup(
					  ipAddress = randomlyPickedIp
					, fields    = "country"
					, lang      = "de"
					, referer   = "dummy-referrer"
				);

				expect( result.country ).toBe( "Australien" );
			} );


			it( "should return success=false when given bad api key", function(){
				var result = new cbwhois.models.WhoIsApi().lookup(
					  ipAddress = randomlyPickedIp
					, apiKey    = "abadapikey"
				);

				expect( result.success ).toBe( false );
			} );

			it( title="should use pro features when API key passed and told to do so", skip=!Len( apiKey ), body=function(){
				var result = new cbwhois.models.WhoIsApi().lookup(
					  ipAddress        = randomlyPickedIp
					, apiKey           = apiKey
					, getSecurityInfo  = true
					, getRateUsageInfo = true
				);

				expect( IsStruct( result.rate ?: "" ) ).toBe( true );
				expect( IsStruct( result.security ?: "" ) ).toBe( true );
			} );
		} );

		describe( title="bulkLookup( ipAddresses, apiKey )", skip=!Len( apiKey ), body=function(){
			it( "should allow bulk lookups using a pro api key", function(){
				var result = new cbwhois.models.WhoIsApi().bulkLookup(
					  ipAddresses = [ randomlyPickedIp, anotherRandomlyPickedIp ]
					, apiKey      = apiKey
					, fields      = "country"
					, lang        = "de"
				);

				expect( IsArray( result ) ).toBe( true );
				expect( ArrayLen( result ) ).toBe( 2 );
				expect( StructKeyList( result[ 1 ] ) ).toBe( "country" );
				expect( result[ 1 ].country ).toBe( "Australien" );
			} );
		} );
	}

}