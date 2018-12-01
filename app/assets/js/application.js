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
          editHandler(this,2, 5)
        }else if(this.textContent === 'Update'){
          updateHandler(this, '/user/')
        }
      })
    })
  }

  //-----item page------------------------------------------------------------------------
  if (verifyController('item')){

    const createForm = document.querySelector(".item_create_form")
    const itemLists = document.querySelectorAll(".item_list")
    const updateBtn = document.querySelector('#edition_submit')
    const createForm_select = createForm.querySelector('select[name="category"]')
    const selector = document.getElementById('category_selector')
    const updateForm = document.querySelector(".item_edit_form")

    function renderItemHTML(item){
      return `
        <div class="card" id="item_${item.id}">
          <div class="card-body">
            <div class="row">
              <div class="col col-lg-2 image">
                <img src="${item.image_url}" height="50" width="50">
              </div>
              <div class="col col-lg-6 info">
                <span style= "display:block" class='name'>${item.name}</span>
                <span class='badge badge-dark price'> 價格: ${item.price}</span>
                <span class='badge badge-dark cost'> 成本: ${item.cost === undefined ? 0 : item.cost}</span>
                <span class='badge badge-dark quantity'> 數量: ${item.quantity}</span>
              </div>
              <div class="col col-lg-2 btns">
                <div class="btn-group btn-group-sm ml-5 mt-4" role="group" aria-label="Basic example">
                  <button type="button" class="btn btn-secondary" data-type='edit' data-toggle="modal" data-target=".edition">編輯</button>
                  <button type="button" class="btn btn-secondary" data-type='delete'>刪除</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      `
    }

    function updateSubmit(e){
      const form = e.path[1]
      const inputs = form.querySelectorAll("input")
      let data ={
        name: inputs[0].value,
        price: inputs[1].value,
        cost: inputs[2].value,
        quantity: inputs[3].value,
        image_url: inputs[4].value
      }
      $.ajax({
        url: `/api/v1/item/${form.id}`,
        data: data,
        type: 'PUT',
        success: function(data) {
          item = JSON.parse(data)
          item_card = document.getElementById(`item_${item.id}`)
          console.log(item_card)
          item_card.querySelector('.info .name').innerText = item.name
          item_card.querySelector('.info .price').innerText = `價格: ${item.price}`
          item_card.querySelector('.info .cost').innerText = `成本: ${item.cost}`
          item_card.querySelector('.info .quantity').innerText = `數量: ${item.quantity}`
          item_card.querySelector('.image img').src = item.image_url
        }
      });
    }
    //-----------------------------create new item---------------------------------
    function createSubmit(e){
      e.preventDefault();
      const form = e.target
      const inputs = form.querySelectorAll("input")
      const select = form.querySelector('select')
      let data ={
        name: inputs[0].value,
        price: inputs[1].value,
        cost: inputs[2].value,
        quantity: inputs[3].value,
        image_url: inputs[4].value,
        category: select.value
      }
       $.post('/item', data, function(item, status){
        if ( item.category == selector.value){
          itemLists[1].insertAdjacentHTML('beforeend', renderItemHTML(item));
        }
        Alert(`成功新增了${item.name}`)
      }) 
      form.reset();
    }

    function itemBtnClick(e) {
      if (!e.target.matches('button')) return;
      const btn = e.target
      const item = e.path[5]
      const inputs = updateForm.querySelectorAll('input')
      if( btn.dataset.type === 'edit') {
        updateForm.id = item.id.split('_')[1]
        inputs[4].value = item.querySelector('.image img').src
        inputs[0].value = item.querySelector('.info .name').innerHTML
        inputs[1].value = item.querySelector('.info .price').innerHTML.split(':')[1].replace(/ /g,'')
        inputs[2].value = item.querySelector('.info .cost').innerHTML.split(':')[1].replace(/ /g,'')
        inputs[3].value = item.querySelector('.info .quantity').innerHTML.split(':')[1].replace(/ /g,'')  
      }
      else if( btn.dataset.type === 'delete') {
        console.log(`/api/v1/item/${item.id.split('_')[1]}`)
        $.ajax({
          url: `/api/v1/item/${item.id.split('_')[1]}`,
          type: 'DELETE',
          success: function(data) {
            console.log(data)
            item.parentNode.removeChild(item)
          }
        });
      }
    }

    function changeItemList(){
      $.get(`/api/v1/items?category=${this.value}`, function(data, status){
        items = JSON.parse(data)['items']
        console.log(items)
        const half_items = items.splice(0, items.length/2)
        itemLists[0].innerHTML = half_items.map(item => renderItemHTML(item)).join('')
        itemLists[1].innerHTML = items.map(item => renderItemHTML(item)).join('')
      })
      console.log(this)
      if (this.id === "category_selector"){
        createForm_select.value = this.value
      }
      else{
        selector.value = this.value
      }
    }

    updateBtn.addEventListener('click', updateSubmit)
    createForm.addEventListener('submit', createSubmit)
    itemLists.forEach(item => item.addEventListener('click', itemBtnClick))
    selector.addEventListener('change', changeItemList)
    createForm_select.addEventListener('change', changeItemList)
  }

  //-------------------------------transaction page------------------------------
  if (verifyController('transaction')) {
    select = document.getElementById('transaction_filter').querySelector('select')
    
    function renderTransactions(){
      $.get(`/api/v1/transactions/${this.value}`, function(data, status){
        console.log(data)
        const transactions = JSON.parse(data).transactions
        const transactions_list = document.querySelector('ul.transactions')
        const html = transactions.map(transaction =>
          `<li class="list-group-item paid-${transaction.status}">
            ItmeName:${transaction.item.name}; Amount:${transaction.amount}
          </li>`
        ).reduce((html, li) =>  { return html + li}, '')
        transactions_list.innerHTML = html
      })
    }


    select.addEventListener('change', renderTransactions)
  }

}