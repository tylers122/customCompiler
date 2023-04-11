fn add(a, b) {
  return a + b;
}

fn mult(a, b) {
  return a * b;
}

fn main() {

  var a;
  var b;
  var c;
  var d;
  
  a = 100;
  b = 50;
  c = add(a, b);
  print(c);        //should print 150   
  
  d == mult(c, a + b);
  print(d);        //should print "22500", since 22500 = 150 * 150;
}
