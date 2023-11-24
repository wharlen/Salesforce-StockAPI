
@isTest
public with sharing class AcoesBolsaValoresBatchableTest {
    @TestSetup
    static void makeData(){
        Acoes__c acao = new Acoes__c(
            URL__c = 'https://s3-symbol-logo.tradingview.com/brasileiro-petrobras--big.svg',
            Stock__c = 'PETR4',
            Price__c = 13.2,
            Change__c = 13.2,
            High__c = 13.2,
            Low__c = 13.2,
            Currency__c = 'BRL',
            Ult_Atualizacao__c = Datetime.now().addMinutes(-5)
        );
        insert acao;
    }

    @isTest
    static  void atualizarGarantiaAtivosTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AtualizaAcoesBolsaValoresBatchable batch = new AtualizaAcoesBolsaValoresBatchable();
        Database.executeBatch( batch );
        Test.stopTest();
 }
    @isTest
    static void agendarBatchTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AcoesBolsaValoresScheduler sch = new AcoesBolsaValoresScheduler();
        sch.execute(null);
        Test.stopTest();
    }
}