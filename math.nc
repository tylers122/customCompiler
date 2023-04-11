fn main() {
    var a;
    var b;
    var c;

    a = 100;
    b = 50;

    // Addition, answer is 150, since 150 == 100+50
    c = a + b;
    print(c);

    // Subtraction, answer is 50, since 50 == 100-50
    c = a - b;
    print(c);

    // Multiplication, answer is 5000, since 5000 == 100 * 50
    c = a * b;
    print(c);

    // Division, answer is 2, since 2 == 100/50
    c = a / b;
    print(c);

    // Modulus, answer is 0, since 0 == 100 % 50
    c = a % b;
    print(c);

    // "Complex" Expression.
    a = 4;
    b = 2;
    c = (a + b) * 7;
    print(c);
}
