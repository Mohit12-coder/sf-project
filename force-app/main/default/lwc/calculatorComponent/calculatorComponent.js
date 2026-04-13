import { LightningElement } from 'lwc';

export default class CalculatorComponent extends LightningElement {
    expression = '';
    result = '';

    handleChange(event){
        this.expression = event.target.value;
    }

    handleCalculate(){
        try{
            this.result = this.calculate(this.expression);
        }catch(error){
            this.result = 'Invalid Expression';
        }
    }

   calculate(exp){
    exp = exp.replace(/[^0-9+\-*/().]/g, '');
    return eval(exp);
   }

}