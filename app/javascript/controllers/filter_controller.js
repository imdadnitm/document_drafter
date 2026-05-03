import{Controller}from"@hotwired/stimulus";

export default class extends Controller{
    
    submit(event){
        if(event.key === "Enter"){
            this.element.closest("form").requestSubmit();
      }
    }
}