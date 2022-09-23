
function alertMessage() {
  self.close();
}

window.logger = (flutter_value) => {
   console.log({ js_context: this, flutter_value });
}