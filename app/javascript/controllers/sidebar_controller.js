import {Controller} from "@hotwired/stimulus"

export default class extends Controller{

    static targets = ["generated_doc_item", "template_item", "user_account"]

    async nav_item_css_change(event){

        this.generated_doc_itemTarget.classList.remove("bg-indigo-50","text-indigo-700")
        this.template_itemTarget.classList.remove("bg-indigo-50","text-indigo-700")
        this.user_accountTarget.classList.remove("bg-indigo-50","text-indigo-700")

        this.generated_doc_itemTarget.classList.add("text-gray-500","hover:bg-gray-100", "hover:text-gray-700")
        this.template_itemTarget.classList.add("text-gray-500","hover:bg-gray-100", "hover:text-gray-700")
        this.user_accountTarget.classList.add("text-gray-500","hover:bg-gray-100", "hover:text-gray-700")
        

        event.currentTarget.classList.remove("text-gray-500","hover:bg-gray-100", "hover:text-gray-700")
        event.currentTarget.classList.add("bg-indigo-50","text-indigo-700")
        
        console.log(event.currentTarget.classList)
        
    }
}