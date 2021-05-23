World world;

void setup() {
    size(720, 720);

    // World(gravity, air_resistance, delta_time)
    world = new World(new PVector(0, 10), 0, 0.05);
    // Ball(position, velocity, mass, radius)
    world.add_obj(new Ball(new PVector(width / 2, 100), new PVector(0, 0), 10, 20));
    world.add_obj(new Ball(new PVector(width / 2, height / 2), new PVector(0, 0), 10, 20));
    // Floor(height)
    world.add_obj(new Floor(600));
}

void draw() {
    background(255);

    world.reset_gravity();
    world.calc_collide();
    world.update();
    world.draw();
}