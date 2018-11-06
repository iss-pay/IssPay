window.onload = function(){

  function verifyController(controller_name){
    return document.querySelector('#'+ controller_name) !== null
  }

  if (verifyController('user')){
    
    const editButtons = document.querySelectorAll('button.edit')

    function editHandler(btn){
      const user_tr = document.getElementById(btn.dataset.user)
      let tds = Array.from(user_tr.querySelectorAll('td')).slice(2, 8)
      tds.forEach(td => {
        const html = `<input name="${td.dataset.attr}" value="${td.textContent}">`
        td.innerHTML = html
      });
      btn.textContent = 'Update'
    }

    function updateHandler(btn){
      const user_tr = document.getElementById(btn.dataset.user)
      let inputs = Array.from(user_tr.querySelectorAll('input'))
      data = {}
      inputs.forEach(input => { data[input.name] = input.value })
      $.ajax({
        url: '/user/' + btn.dataset.user,
        type: 'PUT',
        data: data,
        success: function(data){
          inputs.forEach(input => {
            input.outerHTML = input.value
          });
        }
      })
      btn.textContent = 'Edit'
    }

    editButtons.forEach(btn => {
      btn.addEventListener('click', function(){
        if(this.textContent === 'Edit'){
          editHandler(this)
        }else if(this.textContent === 'Update'){
          updateHandler(this)
        }
      })
    })
  }

}