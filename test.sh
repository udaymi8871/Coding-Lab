#!/bin/bash

# Fail script if any command fails
set -e

echo "Running calculator tests (JSDOM)..."

# Run Node inline script to execute tests using jsdom
node << 'EOF'
const fs = require("fs");
const { JSDOM } = require("jsdom");

function logPass(name){ console.log(`PASS: ${name}`); }
function logFail(name, err){ console.log(`FAIL: ${name} - ${err}`); }

try {
  const html = fs.readFileSync("index.html", "utf-8");
  const script = fs.readFileSync("script.js", "utf-8");

  const dom = new JSDOM(html, { runScripts: "dangerously", resources: "usable" });
  const window = dom.window;
  const document = window.document;

  // inject JS file contents so functions are available
  const scriptTag = document.createElement("script");
  scriptTag.textContent = script;
  document.body.appendChild(scriptTag);

  function test(name, fn) {
    try {
      fn();
      logPass(name);
    } catch (err) {
      logFail(name, err.message || err);
      // throw to make the whole node process non-zero if you want failure to stop the bash run
      throw err;
    }
  }

  // Tests
  test("Addition works", () => {
    document.getElementById("num1").value = 5;
    document.getElementById("num2").value = 4;
    window.add();
    if (document.getElementById("result").innerText != '9') throw new Error("Expected 9");
  });

  test("Subtraction works", () => {
    document.getElementById("num1").value = 10;
    document.getElementById("num2").value = 6;
    window.subtract();
    if (document.getElementById("result").innerText != '4') throw new Error("Expected 4");
  });

  test("Multiplication works", () => {
    document.getElementById("num1").value = 3;
    document.getElementById("num2").value = 4;
    window.multiply();
    if (document.getElementById("result").innerText != '12') throw new Error("Expected 12");
  });

  test("Division works", () => {
    document.getElementById("num1").value = 12;
    document.getElementById("num2").value = 3;
    window.divide();
    if (document.getElementById("result").innerText != '4') throw new Error("Expected 4");
  });

  test("Division by zero handled", () => {
    document.getElementById("num1").value = 5;
    document.getElementById("num2").value = 0;
    window.divide();
    if (document.getElementById("result").innerText !== "Cannot divide by zero")
      throw new Error("Expected 'Cannot divide by zero'");
  });

  // If we reach here all tests passed
  console.log("All tests passed.");

} catch (err) {
  // Node will exit non-zero because we re-throw inside test on failure; but also print summary here
  console.error("One or more tests failed.");
  process.exit(1);
}
EOF

echo "Test script finished."
