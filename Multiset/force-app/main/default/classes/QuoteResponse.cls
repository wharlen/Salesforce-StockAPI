public with sharing class QuoteResponse {
    public List<StockInfo> results;
    public class StockInfo{
        public String logourl;
        public String symbol;
        public Decimal regularMarketPrice;
        public Decimal regularMarketDayHigh;
        public Decimal regularMarketDayLow;
        public Decimal regularMarketChangePercent;
        public String currency_x;
    }
}