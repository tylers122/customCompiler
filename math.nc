fn main() {
    let a = 0;
    let b = 0;
    let c = 0;

    a = 100;
    b = 50;

    // Addition, answer is 150, since 150 := 100+50
    c = a + b;
    write(c);

    // Subtraction, answer is 50, since 50 := 100-50
    c = a - b;
    write(c);

    // Multiplication, answer is 5000, since 5000 := 100 * 50
    c = a * b;
    write(c);

    // Division, answer is 2, since 2 := 100/50
    c = a / b;
    write(c);

    // Modulus, answer is 0, since 0 := 100 % 50
    c = a % b;
    write(c);

    // "Complex" Expression.
    a = 4;
    b = 2;
    c = (a + b) * 7;
    write(c);
}
