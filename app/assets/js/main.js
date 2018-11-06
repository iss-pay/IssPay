window.onload = function(){
  console.log('window loaded.');
  
  function verifyController(controller_name){
    return document.querySelector('#'+ controller_name) !== null
  }


  
  if (verifyController('home')){
    
    $.get("/chart/user_purchased", function(data, status){
      new Chartkick.LineChart("chart-test", data, {adapter: 'google'});
    })
  }

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