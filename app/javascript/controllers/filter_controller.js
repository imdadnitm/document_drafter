import{Controller}from"@hotwired/stimulus";

export default class extends Controller{
    
    submit(event){

        if(event.key === "Enter"){
            this.element.closest("form").requestSubmit();
      }
    }

    submit_on_date_change(){
        this.element.closest("form").requestSubmit();
    }

    submitWithDelay() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.element.closest("form").requestSubmit();
    }, 400)
  }
}