/**
 * Inspired by Jeffrey Berger https://twitter.com/jeffereyberger/status/877246726112980992
 *
 * Developed by Doug Ayers, douglascayers.com
 */
@isTest
private class MultiPicklistFieldCompareInvocableTest {

    @isTest
    static void test_null_field_values() {

        String picklistA = null;
        String picklistB = null;

        MultiPicklistFieldCompareInvocable.Request req = new MultiPicklistFieldCompareInvocable.Request();
        req.picklistA = picklistA;
        req.picklistB = picklistB;

        Test.startTest();

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ req };
        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute( requests );

        Test.stopTest();

        System.assertEquals( null, responses[0].commonValues );
        System.assertEquals( null, responses[0].uniqueValuesA );
        System.assertEquals( null, responses[0].uniqueValuesB );

    }

    @isTest
    static void test_only_common_values() {

        // in apex, the values from multi-select
        // picklists are simply delimited strings
        String picklistA = 'Apple;Banana';
        String picklistB = 'Apple;Banana';

        MultiPicklistFieldCompareInvocable.Request req = new MultiPicklistFieldCompareInvocable.Request();
        req.picklistA = picklistA;
        req.picklistB = picklistB;

        Test.startTest();

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ req };
        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute( requests );

        Test.stopTest();

        Set<String> expectedCommonValues = new Set<String>{ 'Apple', 'Banana' };
        System.assertEquals( expectedCommonValues.size(), responses[0].commonValues.size() );
        System.assert( expectedCommonValues.containsAll( responses[0].commonValues ) );

        System.assertEquals( null, responses[0].uniqueValuesA );
        System.assertEquals( null, responses[0].uniqueValuesB );

    }

    @isTest
    static void test_only_unique_values() {

        // in apex, the values from multi-select
        // picklists are simply delimited strings
        String picklistA = 'Apple;Banana';
        String picklistB = 'One;Two';

        MultiPicklistFieldCompareInvocable.Request req = new MultiPicklistFieldCompareInvocable.Request();
        req.picklistA = picklistA;
        req.picklistB = picklistB;

        Test.startTest();

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ req };
        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute( requests );

        Test.stopTest();

		System.assertEquals( null, responses[0].commonValues );

        Set<String> expectedUniqueValuesA = new Set<String>{ 'Apple', 'Banana' };
        System.assertEquals( expectedUniqueValuesA.size(), responses[0].uniqueValuesA.size() );
        System.assert( expectedUniqueValuesA.containsAll( responses[0].uniqueValuesA ) );

        Set<String> expectedUniqueValuesB = new Set<String>{ 'One', 'Two' };
        System.assertEquals( expectedUniqueValuesB.size(), responses[0].uniqueValuesB.size() );
        System.assert( expectedUniqueValuesB.containsAll( responses[0].uniqueValuesB ) );

    }

    @isTest
    static void test_common_and_unique_values() {

        // in apex, the values from multi-select
        // picklists are simply delimited strings
        String picklistA = 'Apple;Orange;Banana';		// obj1.picklist__c
        String picklistB = 'Apple;Pear;Plum;Orange';	// obj2.picklist__c

        MultiPicklistFieldCompareInvocable.Request req = new MultiPicklistFieldCompareInvocable.Request();
        req.picklistA = picklistA;
        req.picklistB = picklistB;

        Test.startTest();

        List<MultiPicklistFieldCompareInvocable.Request> requests = new List<MultiPicklistFieldCompareInvocable.Request>{ req };
        List<MultiPicklistFieldCompareInvocable.Response> responses = MultiPicklistFieldCompareInvocable.execute( requests );

        Test.stopTest();

        Set<String> expectedCommonValues = new Set<String>{ 'Apple', 'Orange' };
        System.assertEquals( expectedCommonValues.size(), responses[0].commonValues.size() );
        System.assert( expectedCommonValues.containsAll( responses[0].commonValues ) );

        Set<String> expectedUniqueValuesA = new Set<String>{ 'Banana' };
        System.assertEquals( expectedUniqueValuesA.size(), responses[0].uniqueValuesA.size() );
        System.assert( expectedUniqueValuesA.containsAll( responses[0].uniqueValuesA ) );

        Set<String> expectedUniqueValuesB = new Set<String>{ 'Pear', 'Plum' };
        System.assertEquals( expectedUniqueValuesB.size(), responses[0].uniqueValuesB.size() );
        System.assert( expectedUniqueValuesB.containsAll( responses[0].uniqueValuesB ) );

    }

}