public with sharing class AcoesBolsaValoresIntegracao extends IntegracaoRest {
    private IntegracacaoBrapi__mdt integracaoData {get;set;}

    public AcoesBolsaValoresIntegracao(){
        integracaoData = getIntegrationData();
    }

    public HttpResponse getQuote(String stocks, String interval) {
        HttpResponse response;
        try{
            HttpRequest request = createRequest('GET', 
                'quote/'+stocks+'?interval='+interval+'&token='+integracaoData.Token__c, 
                integracaoData.Endpoint__c, 
                'false', 
                false, 
                new Map<String, String>{'Content-Type' => 'application/json',
                'Accept' => 'application/json'}
            );
            Http sender = new Http();
            response = sender.send(request);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage() + ' - ' + e.getStackTraceString());
            System.debug(LoggingLevel.ERROR, response);
            throw new AcoesBolsaValoresIntegracaoException(e.getMessage());
        }
        return response;
    }

    private IntegracacaoBrapi__mdt getIntegrationData(){
        return [SELECT Endpoint__c, Token__c FROM IntegracacaoBrapi__mdt LIMIT 1];
    }

    public class AcoesBolsaValoresIntegracaoException extends Exception {}
}