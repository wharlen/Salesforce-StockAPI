public virtual class IntegracaoRest {

    public HttpRequest createRequest (String method, String apiMethod, String endpoint, String body,
            Boolean compressed, Map<String, String> headers) {
        HttpRequest request = new HttpRequest();
        try {
            if (String.isEmpty(method) ||
                String.isEmpty(endpoint) ||
                compressed == null) {
            throw new IntegracaoRestException('Os parâmetros informados estão com valor inválido .');
            }
            if (headers == null) {
                headers = new Map<String, String>();
            }
            request.setMethod(method);
            request.setTimeout(120000);
            request.setEndpoint(endpoint + apiMethod);
            request.setBody(body);
            request.setCompressed(compressed);
            for (String headerKey: headers.keySet()) {
                request.setHeader(headerKey, headers.get(headerKey));
            }
            return request;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new IntegracaoRestException(e.getMessage());
        }
    }

    public class IntegracaoRestException extends Exception {}
}