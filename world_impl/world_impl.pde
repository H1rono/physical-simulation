World world;

void setup() {
    size(720, 720);

    // World(gravity, air_resistance, delta_time)
    world = new World(new PVector(0, 10), 0, 0.05);
    // Ball(position, velocity, mass, radius)
    // Box(position, velocity, mass, w_len, h_len)
    world.add_obj(new Box(new PVector(100, 560), new PVector(0, 0), 100, 60, 40));
    world.add_obj(new Box(new PVector(130, 539), new PVector(0, 0), 10, 30, 20));
    // Floor(height)
    world.add_obj(new Floor(600));
}

/*
        +------------------+
        |                  |         Box1
        |                  |
        +------------------+
    +--------------------------+
    |                          |
    |                          |
    |                          |     Box2
    |                          |
    +--------------------------+
------------------------------------ Floor
*/

void draw() {
    background(255);

    world.reset_gravity();
    world.calc_collide();
    world.update();
    world.draw();
}