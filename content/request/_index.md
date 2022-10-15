+++
title = "Request for Free JoinBase"
description = "Join us"
date = 2021-09-01T08:00:00+00:00
updated = 2021-12-01T08:00:00+00:00
draft = false

[extra]
class = "page single"
+++

<form id="request_form">
  <div class="mb-3">
    <label for="req_name" class="form-label">Name</label>
    <input type="name" class="form-control" id="req_name" name="name">
  </div>
  <div class="mb-3">
    <label for="req_email" class="form-label">Email</label>
    <input type="email" class="form-control" id="req_email" name="email" aria-describedby="emailHelp">
  </div>
  <div class="mb-3">
    <label for="req_company" class="form-label">Company</label>
    <input class="form-control" id="req_company" name="company">
  </div>
  <div class="mb-3">
    <label for="req_phone" class="form-label">Phone (optional)</label>
    <input class="form-control" id="req_phone" name="phone">
  </div>
  <div class="mb-3">
    <label for="req_comment" class="form-label">Message</label>
    <input class="form-control" id="req_comment" placeholder="any thing you want to tell us" name="comment">
  </div>
  <button type="submit" class="btn btn-primary">Submit</button>
  </form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>  
<script>
//for request form
window.addEventListener("load", () => {
function handleFormSubmit(event) {
  event.preventDefault();
  const data = new FormData(event.target);
  const formJSON = Object.fromEntries(data.entries());
   $.ajax({
       url: 'https://maker.ifttt.com/trigger/ib_user_request/json/with/key/bn_dV-6DJbQPsnVeMFyfsN',
       headers: {
           'Content-Type': 'application/x-www-form-urlencoded'
       },
       type: "POST",
       crossDomain: true,
       dataType: "json",
       data: formJSON,
       success: function (result) {
          alert("Your request has been posted, thank you!");
       },
       error: function () {
          alert("Your request has been posted, thank you!");
       }
   }); 
  //console.log(formJSON);
}
const form = document.getElementById('request_form');
form.addEventListener('submit', handleFormSubmit);
});
</script>
<script> gtag('event', 'conversion', {'send_to': 'AW-10933644303/EdFZCKKhv-IDEI_YyN0o'}); </script>