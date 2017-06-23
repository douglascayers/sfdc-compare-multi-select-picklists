/**
 * Inspired by Jeffrey Berger https://twitter.com/jeffereyberger/status/877246726112980992
 *
 * Developed by Doug Ayers, douglascayers.com
 */
public class MultiPicklistFieldCompareInvocable {

    @InvocableMethod(
        label = 'Multi-Select Picklist Field Compare'
        description = 'Compares two field values from multi-select picklists (or any ; delimited text) and determines similarities'
    )
    public static List<Response> execute( List<Request> requests ) {

        List<Response> responses = new List<Response>();

        for ( Request req : requests ) {

            // avoid null pointer exceptions
            Set<String> picklistValuesA = String.isBlank( req.picklistA ) ? new Set<String>() : new Set<String>( req.picklistA.split('(\\s*;\\s*)') );
            Set<String> picklistValuesB = String.isBlank( req.picklistB ) ? new Set<String>() : new Set<String>( req.picklistB.split('(\\s*;\\s*)') );

            System.debug( 'values in first picklist: ' + picklistValuesA );
            System.debug( 'values in second picklist: ' + picklistValuesB );

            Set<String> commonValues = new Set<String>( picklistValuesA );
            commonValues.retainAll( picklistValuesB );
            System.debug( 'common values in both picklists: ' + commonValues );

            Set<String> uniqueValuesA = new Set<String>( picklistValuesA );
            uniqueValuesA.removeAll( picklistValuesB );
            System.debug( 'unique values in first picklist: ' + uniqueValuesA );

            Set<String> uniqueValuesB = new Set<String>( picklistValuesB );
            uniqueValuesB.removeAll( picklistValuesA );
            System.debug( 'unique values in second picklist: ' + uniqueValuesB );

            Response res = new Response();

            // if this is called from flow, flow can't check if a variable list is empty
            // but it can check if the variable is null. So if any set is empty we return null.
            res.commonValues  = ( commonValues.size() > 0 )  ? new List<String>( commonValues )  : null;
            res.uniqueValuesA = ( uniqueValuesA.size() > 0 ) ? new List<String>( uniqueValuesA ) : null;
            res.uniqueValuesB = ( uniqueValuesB.size() > 0 ) ? new List<String>( uniqueValuesB ) : null;

            responses.add( res );

        }

        return responses;
    }

    // ------------------------------------------------------

    public class Request {

        @InvocableVariable(
            label = 'First Multi-Select Picklist'
            description = 'Value from first multi-select picklist field to compare'
        )
        public String picklistA;

        @InvocableVariable(
            label = 'Second Multi-Select Picklist'
            description = 'Value from second multi-select picklist field to compare'
        )
        public String picklistB;

    }

    public class Response {

        // invocable variables don't support Sets so using Lists

        @InvocableVariable(
            label = 'Common Multi-Select Values'
            description = 'Common values found in both multi-select picklists'
        )
        public List<String> commonValues;

        @InvocableVariable(
            label = 'First Multi-Select Picklist Unique Values'
            description = 'Unique values in first multi-select picklist that are not in second multi-select picklist'
        )
        public List<String> uniqueValuesA;

        @InvocableVariable(
            label = 'Second Multi-Select Picklist Unique Values'
            description = 'Unique values in second multi-select picklist that are not in first multi-select picklist'
        )
        public List<String> uniqueValuesB;

    }

}