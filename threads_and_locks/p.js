const { Worker, isMainThread } = require('worker_threads')

const createChopstick = (id) => ({
    id,
    being_used: false
})

const phylosopher = (left, right, name) => ({ name, left, right })

const run = (p) => {
    while (true) {
        setTimeout(() => {
            console.log("Thinking " + p.name)
        }, 1000);
        if (p.left.being_used == false) {

            if (p.right.being_used == false) {
                p.left.being_used = true;
                p.right.being_used = true;
                setTimeout(() => {
                    console.log("Eating " + p.name)
                }, 1000);
            }
        }
        p.left.being_used = false;
        p.right.being_used = false;
        //return;
    }
}

const dinner = () => {
    
    const c1 = createChopstick(1);
    const c2 = createChopstick(2);
    const c3 = createChopstick(3);
    const c4 = createChopstick(4);
    const c5 = createChopstick(5);

    const p1 = phylosopher(c1, c2, "p1")
    const p2 = phylosopher(c2, c3, "p2")
    const p3 = phylosopher(c3, c4, "p3")
    const p4 = phylosopher(c4, c5, "p4")
    const p5 = phylosopher(c5, c1, "p5")
    run(p1)
    run(p5)
    run(p2)
    run(p3)
    run(p4)
}

dinner();