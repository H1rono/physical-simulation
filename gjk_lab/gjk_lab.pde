World world;

void setup() {
    size(720, 720);
    world = new World(new PVector(0, 9.8));
    world.add_element(new Ball(
        new PVector(100, 100),
        50, 10
    ));
    world.add_element(new ImmoveBox(
        new PVector(width / 2, height - 100),
        width, 100
    ));
}

void draw() {
    // デバッグ用
    if (!keyPressed) { return; }
    background(255);
    world.update(0.05);
    world.draw();
}
