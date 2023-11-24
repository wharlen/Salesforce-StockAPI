public with sharing class AcoesBolsaValoresController {
    private Id userId {get;set;}
    public String message {get;set;}
    public Boolean success {get;set;}

    public AcoesBolsaValoresController(){
        this.userId = UserInfo.getUserId();
    }

    public void salvaAcaoUsuario(String stock) {
        try {
            Id acaoUsuario = [SELECT Id FROM AcoesUsuario__c WHERE OwnerId__c =: userId AND Acao__r.Stock__c =: stock LIMIT 1]?.Id;
            if(acaoUsuario != null){
                message = 'Ação já inserida';
                success = false;
                return;
            }
            
            List<Acoes__c> acoes = new List<Acoes__c>();
            acoes = [SELECT Id FROM Acoes__c WHERE stock__c =: stock LIMIT 1];
            
            if(acoes.isEmpty()){
                AcoesBolsaValoresIntegracao integ = new AcoesBolsaValoresIntegracao();
                HttpResponse response = integ.getQuote(stock, '5m');
                System.debug(LoggingLevel.INFO, response.getBody());

                if(response.getStatusCode() == 200){
                    QuoteResponse data = (QuoteResponse)JSON.deserialize(response.getBody().replace('"currency":', '"currency_x":'), QuoteResponse.class);
                    System.debug(LoggingLevel.INFO, data);
                    
                    Acoes__c acao = createNewAcao(null, data.results[0]);
                    insert acao;

                    insert new AcoesUsuario__c(
                        Acao__c = acao.Id,
                        OwnerId__c = this.userId
                    );

                    message = 'Ação salva com sucesso';
                    success = true;
                }else{
                    message = 'Não foi possível encontrar esta ação.';
                    success = false;
                }
            }else{
                insert new AcoesUsuario__c(
                    Acao__c = acoes[0].Id,
                    OwnerId__c = this.userId
                );
                
                message = 'Ação salva com sucesso';
                success = true;
            }
        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.INFO, e.getStackTraceString());
            message = e.getMessage();
            success = false;
        }
    }

    public void atualizaAcoes(List<Acoes__c> acoes){
        try {
            List<Acoes__c> acoesToUpdate = new List<Acoes__c>();
            QuoteResponse data;

            for(Acoes__c acao : acoes){
                AcoesBolsaValoresIntegracao integ = new AcoesBolsaValoresIntegracao();
                HttpResponse response = integ.getQuote(acao.Stock__c, '5m');
                System.debug(LoggingLevel.INFO, response.getBody());

                if(response.getStatusCode() == 200){
                    data = (QuoteResponse)JSON.deserialize(response.getBody().replace('"currency":', '"currency_x":'), QuoteResponse.class);
                    acoesToUpdate.add(createNewAcao(acao.Id, data.results[0]));
                }
            }

            if(!acoesToUpdate.isEmpty()){
                update acoesToUpdate;
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.INFO, e.getStackTraceString());
        }
    }

    private static Acoes__c createNewAcao(Id acaoId, QuoteResponse.StockInfo stockInfo){
        return new Acoes__c(
            Id = acaoId,
            URL__c = stockInfo.logourl,
            Stock__c = stockInfo.symbol,
            Price__c = stockInfo.regularMarketPrice,
            High__c = stockInfo.regularMarketDayHigh,
            Low__c = stockInfo.regularMarketDayLow,
            Change__c = stockInfo.regularMarketChangePercent,
            Currency__c = stockInfo.currency_x,
            Ult_Atualizacao__c = Datetime.now()
        );
    }

    public List<Acoes__c> getAcoes(){
        List<Acoes__c> acoes = new List<Acoes__c>();
        try {
            Set<Id> acoesId = new Set<Id>();
            for(AcoesUsuario__c acao : [SELECT Acao__c FROM AcoesUsuario__c WHERE OwnerId__c =: userId]){
                acoesId.add(acao.Acao__c);
            } 
            if(!acoesId.isEmpty()){
                acoes = [SELECT Low__c, High__c, Change__c, Price__c, URL__c, Stock__c, Ult_Atualizacao__c FROM Acoes__c WHERE Id IN: acoesId];
            }

            return acoes;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
       return acoes;
    }

    public void delAcao(String stock){
        try {

            List<AcoesUsuario__c> acoesUsuario = [
                SELECT Id 
                FROM AcoesUsuario__c
                WHERE Acao__r.Stock__c =: stock
                AND OwnerId__c =: userId
            ];

            if(acoesUsuario.isEmpty()){
                message = 'Ação não existe.';
                success = false;
                return;
            }

            delete acoesUsuario;

            message = 'Ação deletada com sucesso';
            success = true;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
            System.debug(LoggingLevel.INFO, e.getStackTraceString());
            message = e.getMessage();
            success = false;
        }
    }
}