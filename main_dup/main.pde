final float delta_time = 0.05;
World world;

void setup() {
    size(720, 720);
    world = new World(new PVector(0, 9.8));
    //world.add_element(new Ball(
    //    new PVector(-100, 100),
    //    50, 10,
    //    new PVector(10, -10), true
    //));
    world.add_element(new Box(new PVector(width / 2, height - 50), width, 100, 50, new PVector(0, 0), false));
    world.add_element(new Ball(new PVector(100, 100), 50, 10, new PVector(10, -10), true));
}

void draw() {
    if (!keyPressed) return;
    background(255);
    world.update(delta_time);
    world.draw(this);
}
