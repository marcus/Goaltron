
function writeCSS()
{
  /* WRITE CSS INTO BOXES BENEATH TESTS */
  $$('.test-img').each(function(e){
      id = e.attributes['id'].value
      var code_div = document.createElement('p');
      code_div.innerHTML = saucyGetCSSforElement('#' + id) 
      e.parentNode.appendChild(code_div)
  })
}

Event.onDOMReady(function() {
    writeCSS()
});

//Event.observe(window,'load',writeCSS)