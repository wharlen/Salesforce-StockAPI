import { LightningElement, wire } from 'lwc';
import criaAcaoUsuario from '@salesforce/apex/AcoesBolsaValoresLWC.criaAcaoUsuario'
import getAcoes from '@salesforce/apex/AcoesBolsaValoresLWC.getAcoes'
import delAcao from '@salesforce/apex/AcoesBolsaValoresLWC.delAcao'
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

export default class AcoesBolsaValores extends LightningElement {
    //dados das ações do usuario
    acoes;
    //referencia do wire para chamarmos a atualizacao pelo refreshApex
    acoes_;
    //valor do codigo da acao digitada no modal de inserção
    acao;
    showSpinner = false;
    showModal = false;
    showModalConfirmExclusao = false;

    openModal(event){
        this.showModal = true;
    }

    closeModal(event){
        this.showModal = false;
    }

    closeModalConfirmExclusao(event){
        this.showModalConfirmExclusao = false;
    }

    connectedCallback(){
        this.showSpinner =  true;
    }

    @wire(getAcoes)
    getAcoes(result) {
        this.acoes_ = result;
        let { error, data } = result;
        console.log(error)
        console.log(data)
        if (error) {
          console.log(error);
        } else if (data) {
            let dados = JSON.parse(data);
            console.log(dados)
            this.acoes = dados.data.map((item) => {
                return {
                    'id': item.Id,
                    'stock': item.Stock__c,
                    'low': item.Low__c.toFixed(2),
                    'high': item.High__c.toFixed(2),
                    'price': item.Price__c.toFixed(2),
                    'change': item.Change__c.toFixed(2),
                    'url': item.URL__c,
                    'lastmodified': item.Ult_Atualizacao__c,
                    'currency': item.Currency__c
                }
            });
        }
        this.showSpinner = false;
    }

    addAcao(event){
        this.showSpinner = true
        criaAcaoUsuario({stock: this.acao})
        .then(res =>{
            const data = JSON.parse(res)
            if(data.success){
                this.notificaUsuario('Ação inserida com sucesso', '', 'success')
                this.closeModal();
                refreshApex(this.acoes_);
            }else{
                this.notificaUsuario('Falha ao inserir ação', data.message, 'error')
            }
        })
        .catch(err =>{
            console.log(err);
            this.notificaUsuario('Erro ao add ação', err, 'error')
        })
        this.showSpinner = false;
    }

    handleChangeAcao(event){
        if(event.detail.value != undefined)
            this.acao = event.detail.value;
        else
            this.notificaUsuario('Código inválido', 'Digite um código válido', 'error')
    }

    showModalDel(event){
        console.log(event.detail.stock)
        this.acao = event.detail.stock;
        this.showModalConfirmExclusao = true;
    }

    excluirAcao(event){
        this.showSpinner = true
        console.log(this.acao)
        delAcao({stock:this.acao})
        .then(res=>{
            const data = JSON.parse(res)
            if(data.success){
                this.notificaUsuario('Ação deletada com sucesso', '', 'success')
                this.closeModalConfirmExclusao();
                refreshApex(this.acoes_);
            }else{
                this.notificaUsuario('Falha ao deletar ação', data.message, 'error')
            }
        })
        .catch(err =>{
            console.log(err);
            this.notificaUsuario('Erro ao deletar ação', err, 'error')
        })
        this.showSpinner = false;
    }

    notificaUsuario(tile, message, variant) {
        this.dispatchEvent(
          new ShowToastEvent({
            title: tile,
            message: message,
            variant: variant
          })
        );
    }

}