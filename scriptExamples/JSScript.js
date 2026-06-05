class Bar {
    constructor() {
    }

    toto(a) {
        debugger;
        return "toto";
    }
}

class Foo {
    constructor() {
    }

    bar() {
        return new Bar();
    }
}

const foo = new Foo();
const bar = new Bar();
const x = bar;
const result = foo.bar().toto(x);

x.toto('ok');

console.log(result);