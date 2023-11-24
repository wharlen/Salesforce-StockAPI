import { LightningElement, api } from 'lwc';

export default class AcaoBox extends LightningElement {
    @api acao;
    @api classe;

    get classe(){
        return this.acao.change < 0 ? 'slds-box slds-theme_default negativa' : 'slds-box slds-theme_default positiva'
    }

    excluir(event){
       console.log(event.target.dataset.stock)

       let stockCode = event.target.dataset.stock;
        console.log('id de acao em child:'+stockCode)
        const eventExcluir = new CustomEvent('showmodaldel', {
            detail:{stock:stockCode}
        });
        console.log(eventExcluir)
        this.dispatchEvent(eventExcluir)
    }
}