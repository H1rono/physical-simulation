void draw_arrow(PVector begin, PVector end) {
    line(begin.x, begin.y, end.x, end.y);
    PVector axis = PVector.sub(end, begin).normalize();
    PVector normal = new PVector(axis.y, -axis.x);
    float d = begin.dist(end) / 5;
    axis.mult(-d);
    normal.mult(d);
    PVector p1 = PVector.add(axis, normal).add(end);
    PVector p2 = PVector.sub(axis, normal).add(end);
    triangle(end.x, end.y, p1.x, p1.y, p2.x, p2.y);
}

World world;
Ball ball;

void setup() {
    size(720, 720);
    world = new World(new PVector(0, 0));
    ball = new Ball(
        new PVector(100, 100),
        50, 10
    );
    world.add_element(ball);
    world.add_element(new ImmoveBox(
        new PVector(width / 2, height - 100),
        width, 100
    ));
}

void draw() {
    // デバッグ用
    // if (!keyPressed) { return; }
    background(255);
    ball.get_center().set(mouseX, mouseY);
    world.draw();
    world.update(0.05);
}

void mousePressed() {
    println("(" + mouseX + ", " + mouseY + ")");
}
