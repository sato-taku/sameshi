document.addEventListener('turbo:load', function() {
  // id: "input"の入力フィールドを選択
  const inputElement = document.querySelector("#input");
  // id: "preview"の要素を選択
  const previewElement = document.querySelector("#preview");

  if (inputElement && previewElement) {
    inputElement.addEventListener("change", function() {
      const file = this.files[0];
      if (file) {
        const reader = new FileReader();
  
        reader.onload = function(e) {
          previewElement.src = e.target.result;
        };
  
        reader.readAsDataURL(file);
      }
    });
  }
});