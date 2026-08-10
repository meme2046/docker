// Simple Dart Demo, no external libraries
void main() {
  var msg = "hello world";
  int a = 10;
  int b = 20;
  print(msg);
  print(a + b);

  if (a > 5) {
    print("big");
  } else {
    print("small");
  }

  for (var i = 0; i < 5; i++) {
    print("index: $i");
  }

  String greet(String name) {
    return "Hi, $name !";
  }

  print(greet("test user"));
}
