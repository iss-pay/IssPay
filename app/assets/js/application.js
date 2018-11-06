window.onload = function(){

  function Alert(msg){
    const alert = document.querySelector('.alert ');
    const alertContent = alert.querySelector('.message');
    alertContent.textContent = msg;
    alert.style.display = 'block'; 
  }

  function verifyController(controller_name){
    return document.querySelector('#'+ controller_name) !== null
  }

  // -----------------------home page----------------------------- 
  if (verifyController('home')){
    $.get("/chart/user_purchased", function(data, status){
      new Chartkick.LineChart("chart-test", data, {adapter: 'google'});
    })

    const selects = document.querySelectorAll('.purchase_form select')
    const form_btn = document.querySelector('.purchase')

    function purchase(){
      const user_id = document.getElementById('current_user').dataset.id
      const drink_id = selects[0].value
      const snack_id = selects[1].value
      let item_ids = 'null'
      if(drink_id !== 'null'){
        if(snack_id === 'null') item_ids = "item_ids[]="+drink_id
        if(snack_id !== 'null') item_ids = `item_ids[]=${drink_id}&item_ids[]=${snack_id}`
      }else if (snack_id !== 'null'){
        item_ids = "item_ids[]="+snack_id
      }
      if(item_ids !== 'null'){
        $.get(`/api/v1/add_transaction?type=purchase&message_id=${user_id}&${item_ids}`, function(data, status){
          items = data.transactions.reduce((item, t) => {
            return item + t.item.name + ";"
          },"")
          Alert(`成功購買 - ${items}`)
        })
      }
    }

    function selectChange(){
      const drink_price = parseInt(selects[0].selectedOptions[0].dataset.price) 
      const snack_price = parseInt(selects[1].selectedOptions[0].dataset.price) 
      const amount = document.getElementById('amount')
      amount.textContent = drink_price+snack_price
    }
    form_btn.addEventListener('click', purchase)
    selects.forEach(select => select.addEventListener('change', selectChange))
  }

  //--------------------------------user page---------------------------------------------
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

  //-------------------------------item page---------------------------------------
  if (verifyController('item')){

    const item_form = document.querySelector(".item_form")
    const item_submit = document.querySelector(".item_form .btn")

    function submitForm(){
      console.log('click')
      const inputs = item_form.querySelectorAll("input")
      const select = item_form.querySelector('select')
      const data ={
        name: inputs[0].value,
        price: inputs[1].value,
        quantity: inputs[2].value,
        image_url: inputs[3].value,
        category: select.value
      }
      $.post('/item', data, function(item, status){
        console.log(item)
        const table = document.querySelector('.'+item.category+'s')
        const html = `<tr>
                        <th scope='row'> ${item.amount} </th>
                        <td>${item.name}</td>
                        <td>${item.quantity}</td>
                        <td>${item.price}</td>
                        <td> <img src="${item.image_url}" width="60" height="60"></td>
                        <td> ${item.category} </td>
                        <td>
                          <div class="btn-group-sm btn-group" role='group'>
                            <button class='btn btn-success'>Edit</button>
                            <button class='btn btn-success'>Delete</button>
                          </div>
                        </td>
                      </tr>`          
        console.log(html)
        table.insertAdjacentHTML('beforeend', html)
      })
    }

    item_submit.addEventListener('click', submitForm)
  }

}