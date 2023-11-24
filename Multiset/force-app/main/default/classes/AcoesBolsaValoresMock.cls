@isTest
public class AcoesBolsaValoresMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse res = new HttpResponse();
        String json;
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        if (request.getEndpoint().contains('INVALID')) {
            json = '{'+
                '\"error\": true,'+
                '\"message\": \"Não encontramos a ação TSLART34\"'+
            '}';
            res.setStatusCode(404);
        }else if (request.getEndpoint().contains('quote')) {
            json = mock();
            res.setStatusCode(200);
        }
    
        res.setBody(json);
        return res;
    }

    static String mock(){
        return '{'+
        '    "results": ['+
        '        {'+
        '            "symbol": "PETR4",'+
        '            "currency": "BRL",'+
        '            "twoHundredDayAverage": 29.73655,'+
        '            "twoHundredDayAverageChange": 5.9234505,'+
        '            "twoHundredDayAverageChangePercent": 0.19919764,'+
        '            "marketCap": 483446160000,'+
        '            "shortName": "PETROBRAS   PN      N2",'+
        '            "longName": "Petróleo Brasileiro S.A. - Petrobras",'+
        '            "regularMarketChange": 0.49000168,'+
        '            "regularMarketChangePercent": 1.3932377,'+
        '            "regularMarketTime": "2023-11-24 15:04:24+00",'+
        '            "regularMarketPrice": 35.66,'+
        '            "regularMarketDayHigh": 35.68,'+
        '            "regularMarketDayRange": "34.71 - 35.68",'+
        '            "regularMarketDayLow": 34.71,'+
        '            "regularMarketVolume": 23430400,'+
        '            "regularMarketPreviousClose": 35.17,'+
        '            "regularMarketOpen": 34.98,'+
        '            "averageDailyVolume3Month": 49685720,'+
        '            "averageDailyVolume10Day": 55009112,'+
        '            "fiftyTwoWeekLowChange": 14.889999,'+
        '            "fiftyTwoWeekLowChangePercent": 0.71689934,'+
        '            "fiftyTwoWeekRange": "20.77 - 38.86",'+
        '            "fiftyTwoWeekHighChange": -3.2000008,'+
        '            "fiftyTwoWeekHighChangePercent": -0.0823469,'+
        '            "fiftyTwoWeekLow": 20.77,'+
        '            "fiftyTwoWeekHigh": 38.86,'+
        '            "priceEarnings": 3.40290943,'+
        '            "earningsPerShare": 10.4968915,'+
                    '"logourl": "https://s3-symbol-logo.tradingview.com/brasileiro-petrobras--big.svg",'+
        '            "updatedAt": "2023-11-24 15:19:28.024+00"'+
        '        }'+
        '    ],'+
        '    "requestedAt": "2023-11-24T15:21:34.325Z",'+
        '    "took": "6ms"'+
        '}';
    }

    static String getDataMock(){
        QuoteResponse quote = new QuoteResponse();
        QuoteResponse.StockInfo stockInfo = new QuoteResponse.StockInfo();
        stockInfo.logourl = 'https://s3-symbol-logo.tradingview.com/brasileiro-petrobras--big.svg';
        stockInfo.symbol = 'PETR4';
        stockInfo.regularMarketPrice = 13.2;
        stockInfo.regularMarketDayHigh = 13.2;
        stockInfo.regularMarketDayLow = 13.2;
        stockInfo.regularMarketChangePercent = 13.2;
        stockInfo.currency_x = 'BRL';
        quote.results = new List<QuoteResponse.StockInfo>{stockInfo};
        return JSON.serialize(quote);
    }
}