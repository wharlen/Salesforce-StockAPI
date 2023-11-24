public with sharing class AcoesBolsaValoresLWC {

    @AuraEnabled(cacheable=false)
    public static string criaAcaoUsuario(String stock){
        Response res = new Response();
        try {
            if(stock == null) throw new AcoesBolsaValoresLWCException('Necessário digitar um código.');
            
            AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
            controller.salvaAcaoUsuario(stock);
            res.message = controller.message;
            res.success = controller.success;
        } catch (Exception e) {
            res.message = e.getMessage();
            res.success = false;
        }
        return JSON.serialize(res);
    }

    @AuraEnabled(cacheable=true)
    public static String getAcoes(){
        Response res = new Response();
        try {
            AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
            res.data = controller.getAcoes();
            res.success = true;

        } catch (Exception e) {
            res.message = e.getMessage();
            res.success = false;
        }
        return JSON.serialize(res);
    }

    @AuraEnabled
    public static String delAcao(String stock){
        Response res = new Response();
        try {
            if(stock == null) throw new AcoesBolsaValoresLWCException('Necessário digitar um código.');

            AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
            controller.delAcao(stock);
            res.success = controller.success;
            res.message = controller.message;
            
        } catch (Exception e) {
            res.message = e.getMessage();
            res.success = false;
        }
        return JSON.serialize(res);
    }

    public class Response{
        Boolean success;
        String message;
        List<Acoes__c> data;
    }

    public class AcoesBolsaValoresLWCException extends Exception {}
}