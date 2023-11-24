global class AcoesBolsaValoresScheduler implements Schedulable {
    
    public static String CRON_EXP = '0 5 * * * * 2050';
    
    global void execute(SchedulableContext SC) 
    {   
        AtualizaAcoesBolsaValoresBatchable bc = new AtualizaAcoesBolsaValoresBatchable();
        Database.executeBatch(bc);
    }

}