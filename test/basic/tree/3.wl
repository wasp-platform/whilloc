function main() {
    i = symbol_int("i");
    j = symbol_int("j");
    k = symbol_int("k");
    assume(i>=4);
    assume(i<8);

    assume(j>=0);
    assume(j<3);

    assume(k>=5);
    assume(k<8);

    v = symbol_int("v");
    assume(v != 0);
    assume(v != 42);

    x = new(8);

    x[i] = v;
    x[j] = 42;

    y = x[k];

    assert((y == 0) || (y == 42));

    delete x;
    return x
}
