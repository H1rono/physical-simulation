Rectangle center;
Circle mouse;

PVector get_mouse() {
    return new PVector(
        max(0, min(width, mouseX)),
        max(0, min(height, mouseY))
    );
}

void setup() {
    size(720, 720);
    mouse = new Circle(new PVector(0, 0), 50);
    center = new Rectangle(new PVector(width / 2 - 50, height / 2 - 50), 100, 100);
}

void draw() {
    background(255);
    mouse.set_center(get_mouse());
    center.rotate_by(0.01);
    Box m_aabb = mouse.get_aabb(), c_aabb = center.get_aabb();
    if (m_aabb.is_collide(c_aabb) && new MinkowskiDiff(mouse, center).contains_origin()) {
        // 衝突
        fill(255, 0, 0);
    } else {
        fill(255);
    }
    center.draw();
    mouse.draw();
}