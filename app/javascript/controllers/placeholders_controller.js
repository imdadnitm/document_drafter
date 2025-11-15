import {Controller} from "@hotwired/stimulus"

export default class extends Controller{
    
    static targets = ["file","placeholder","selected_template"]

    async extract_placeholders() {
        alert("Change occurred")
        const uploaded_file = this.fileTarget.files[0]
        if(!uploaded_file)
            return
        
        const formData = new FormData()
        formData.append("template_document",uploaded_file)

        const response = await fetch("/templates/extract_placeholders", {
            method: "POST",
            body: formData,
            headers: {
                "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                "Accept": "application/json"
            }
        })

        const data = await response.json()

        alert(data.placeholders)

        this.placeholderTarget.value = JSON.stringify(data.placeholders)
    }

    async render_placeholders(){

        alert("change occurred")

        const template_id = this.selected_templateTarget.value

        if(!template_id)
            return

        const url = `/generated_documents/render_placeholder_inputs?template_id=${template_id}`

        Turbo.visit(url, {frame:"placeholder_input_frame"})

    }
}