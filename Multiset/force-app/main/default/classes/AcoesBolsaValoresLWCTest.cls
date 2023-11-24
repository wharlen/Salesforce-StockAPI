@isTest
public with sharing class AcoesBolsaValoresLWCTest {
    @TestSetup
    static void makeData(){
        List<Profile> idProfile = new List<Profile>([SELECT Id FROM Profile WHERE Name = 'Administrador do sistema' LIMIT 1]);
        User usuario = new User();
        usuario.alias = 'tdjsw123';
        usuario.LastName = 'testcoverage123';
        usuario.Email = 'teste12343@testcoverage.com.br';
        usuario.ProfileId = idProfile[0].Id;
        usuario.Username = 'teste123@testcoverage.com.br';
        usuario.TimeZoneSidKey = 'America/Sao_Paulo';
        usuario.LocaleSidKey = 'pt_BR';
        usuario.EmailEncodingKey = 'ISO-8859-1';
        usuario.LanguageLocaleKey = 'pt_BR';  
        insert usuario;

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

        insert new AcoesUsuario__c(
            Acao__c = acao.Id,
            OwnerId__c = UserInfo.getUserId()
        );
    }

    @isTest
    static void criaAcaoUsuario_exists_to_user_test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AcoesBolsaValoresLWC.criaAcaoUsuario('PETR4');
        Test.stopTest();
    }

    @isTest
    static void salvaAcaoUsuario_controller_test(){
        AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
        controller.salvaAcaoUsuario(null);
    }

    @isTest
    static void criaAcaoUsuario_exception_test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AcoesBolsaValoresLWC.criaAcaoUsuario(null);
        Test.stopTest();
    }

    @isTest
    static void criaAcaoUsuario_not_exists_to_user_test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AcoesBolsaValoresLWC.criaAcaoUsuario('TSLA34');
        Test.stopTest();
    }

    @isTest
    static void criaAcaoUsuario_existent_acao_to_not_existent_user_test() {
        User usuario = [SELECT Id FROM User WHERE Email = 'teste12343@testcoverage.com.br' LIMIT 1];
        System.runAs(usuario) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
            AcoesBolsaValoresLWC.criaAcaoUsuario('PETR4');
            Test.stopTest();
        }
    }

    @isTest
    static void criaAcaoUsuario_not_exists_test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        AcoesBolsaValoresLWC.criaAcaoUsuario('INVALID');
        Test.stopTest();
    }

    @isTest
    static void getAcoes_test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AcoesBolsaValoresMock());
        String response = AcoesBolsaValoresLWC.getAcoes();

        Test.stopTest();
    }

    @isTest
    static void delAcao_test() {
        AcoesBolsaValoresLWC.delAcao('PETR4');
    }

    @isTest
    static void delAcao_exception_test() {
        AcoesBolsaValoresLWC.delAcao(null);
    }
    
    @isTest
    static void delAcao_not_existent_test() {
        AcoesBolsaValoresLWC.delAcao('INVALID');
    }

    @isTest
    static void delAcao_controller_test(){
        AcoesBolsaValoresController controller = new AcoesBolsaValoresController();
        controller.delAcao(null);
    }
}