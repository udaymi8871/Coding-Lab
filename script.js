function add() {
    let a = +document.getElementById('num1').value;
    let b = +document.getElementById('num2').value;
    document.getElementById('result').innerText = a + b;
  }
  
  function subtract() {
    let a = +document.getElementById('num1').value;
    let b = +document.getElementById('num2').value;
    document.getElementById('result').innerText = a - b;
  }
  
  function multiply() {
    let a = +document.getElementById('num1').value;
    let b = +document.getElementById('num2').value;
    document.getElementById('result').innerText = a * b;
  }
  
  function divide() {
    let a = +document.getElementById('num1').value;
    let b = +document.getElementById('num2').value;
    if (b === 0) {
      document.getElementById('result').innerText = "Cannot divide by zero";
      return;
    }
    document.getElementById('result').innerText = a / b;
  }
  