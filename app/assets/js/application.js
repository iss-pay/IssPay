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

  function editHandler(btn, start, end){
    const tr = document.getElementById(btn.dataset.id)
    let tds = Array.from(tr.querySelectorAll('td')).slice(start, end)
    tds.forEach(td => {
      let html
      if(td.dataset.attr == 'image_url'){
        html = `<input name="${td.dataset.attr}" value="${td.children[0].src}" size="3" >`
      }else{
        html = `<input name="${td.dataset.attr}" value="${td.textContent}" size="3" >`
      }
      td.innerHTML = html
    });
    btn.textContent = 'Update'
  }

  function updateHandler(btn, url){
    const tr = document.getElementById(btn.dataset.id)
    let inputs = Array.from(tr.querySelectorAll('input'))
    data = {}
    inputs.forEach(input => { data[input.name] = input.value })
    $.ajax({
      url: url + btn.dataset.id,
      type: 'PUT',
      data: data,
      success: function(data){
        inputs.forEach(input => {
          if(input.name == "image_url"){
            console.log(input.value)
            input.outerHTML = `<img src="${input.value}" width="60" height="60">`
          }else{
            input.outerHTML = input.value
          }
        });
      }
    })
    btn.textContent = 'Edit'
  }

  // -----------------------home page-----------------------------------------------------
  if (verifyController('home')){
    $.get("/chart/user_purchased", function(data, status){
      new Chartkick.LineChart("chart-test", data, {adapter: 'google'});
    })
    //----------------------purchase item----------------------------
    const selects = document.querySelectorAll('.purchase_form select')
    const form_btn = document.querySelector('.purchase')

    function purchase(){
      const user_id = document.getElementById('current_user').dataset.id
      const drink_id = selects[0].value
      const snack_id = selects[1].value
      let item_ids = []
      if(drink_id !== 'null') item_ids.push(drink_id)
      if(snack_id !== 'null') item_ids.push(snack_id)
      if(item_ids !== 'null'){
        data = {
          "type": "purchase",
          "message_id": user_id,
          "item_ids": item_ids
        }
        $.post("/api/v1/transaction", data, function(transactions, status){
          const response = JSON.parse(transactions)
          items = response['transactions'].reduce((item, t) => {
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

    editButtons.forEach(btn => {
      btn.addEventListener('click', function(){
        if(this.textContent === 'Edit'){
          editHandler(this,2, 8)
        }else if(this.textContent === 'Update'){
          updateHandler(this, '/user/')
        }
      })
    })
  }

  //-------------------------------item page---------------------------------------
  if (verifyController('item')){

    const item_form = document.querySelector(".item_form")
    const item_submit = document.querySelector(".item_form .btn")

    //-----------------------------create new item---------------------------------
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

    const editBtns = document.querySelectorAll("tr .edit")

    editBtns.forEach(btn => {
      btn.addEventListener("click", function(){
        if(this.textContent === 'Edit'){
          editHandler(this, 0, 4)
        }else if(this.textContent === 'Update'){
          updateHandler(this, '/item/')
        }
      })
    })
  }

}