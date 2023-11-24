global class AtualizaAcoesBolsaValoresBatchable implements Database.Batchable<Acoes__c>,Database.AllowsCallouts {
    global Iterable<Acoes__c> start(Database.BatchableContext BC) {
        Datetime ultimos5Minutos = Datetime.now().addMinutes(-5);
        return [
            SELECT Stock__c
            FROM Acoes__c
            WHERE Ult_Atualizacao__c <=: ultimos5Minutos
        ];
    }
    global void execute(Database.BatchableContext bc, List<Acoes__c> scope) {
        AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
        controller.atualizaAcoes(scope);
    }

    global void finish(Database.BatchableContext BC) {}
        
}