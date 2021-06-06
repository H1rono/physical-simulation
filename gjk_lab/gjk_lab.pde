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
    PVector contact = new PVector(0, 0);
    if (mouse.aabb_collide(center)) {
        contact.set(contact_normal(mouse, center));
        if (contact.x == 0 && contact.y == 0) {
            fill(255);
        } else {
            fill(255, 0, 0);
            contact.add(mouse.get_center());
        }
    } else {
        fill(255);
    }
    mouse.draw();
    center.draw();
    circle(contact.x, contact.y, 10);
}