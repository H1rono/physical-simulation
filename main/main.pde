final PVector gravity = new PVector(0, 9.8);
final float delta_time = 0.05;

World world;
Box box1, box2;

void setup() {
    size(720, 720);
    background(255);
    world = new World(new PVector(0, 9.8));
    world.add_element(new Ball(new PVector(width / 2, 200), new PVector(), 10, 30, true));
    world.add_element(new Ball(new PVector(width / 2, 500), new PVector(), 10, 30, true));
    world.add_element(new Box(new PVector(width / 2.0f, height - 50), new PVector(), 10, width, 100, false));
}

void draw() {
    if (key != ENTER) return;
    background(255);
    world.update(delta_time);
    world.draw(this);
}
