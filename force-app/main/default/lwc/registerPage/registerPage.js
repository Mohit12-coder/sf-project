import { LightningElement } from 'lwc';
import sendOTP from '@salesforce/apex/AuthController.sendOTP';
import registerAfterOTP from '@salesforce/apex/AuthController.registerAfterOTP';

export default class RegisterPage extends LightningElement {

    name;
    email;
    password;
    userOtp;
    generatedOtp;
    otpExpiry;
    showOtp = false;

    handleName(e){ 
        this.name = e.target.value; 
    }
    handleEmail(e){ 
        this.email = e.target.value; 
    }
    handlePassword(e){ 
        this.password = e.target.value; 
    }
    handleOtp(e){ 
        this.userOtp = e.target.value; 
    }

    generateOtp() {
        return Math.floor(100000 + Math.random() * 900000).toString();
    }

    async sendOtp() {

        if (!this.name || !this.email || !this.password) {
            alert('Please fill all fields');
            return;
        }

        this.generatedOtp = this.generateOtp();
        this.otpExpiry = Date.now() + ( 5 * 60 * 1000);
        try {
            await sendOTP({
                email: this.email,
                otp: this.generatedOtp
            });

            this.showOtp = true;
            alert('OTP sent to your email');

        } catch (error) {
            console.error(error);
        }
    }

    async register() {

        if (Date.now() > this.otpExpiry) {
            alert('OTP expired');
            return;
        }

        if (this.userOtp !== this.generatedOtp) {
            alert('Invalid OTP');
            return;
        }

        try {
            if (!this.validatePassword()) return;

            const userId = await registerAfterOTP({name: this.name,email: this.email,password: this.password});
            
            if(userId){
                alert('Registration successful');
            }

            this.showOtp = false;
        } catch (error) {
             console.error('FULL ERROR => ', JSON.stringify(error));

            let msg = 'Something went wrong';

            if (error?.body?.message) {
                msg = error.body.message;
            } else if (error?.message) {
                msg = error.message;
            }

            alert(msg);
        }
    }

    validatePassword() {
        const regex = /^(?=.*[A-Z])(?=.*[0-9])(?=.*[\W]).{8,}$/;

        if (!regex.test(this.password)) {
            alert('Password must contain uppercase, number, special character and be 8+ chars');
            return false;
        }
        return true;
    }
}