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
    ConvexRelation relation = makeRelation(mouse, center);
    if (relation.collision) {
        fill(255, 0, 0);
        mouse.get_center().sub(relation.contact_normal);
    } else {
        fill(255);
    }
    mouse.draw();
    center.draw();
}
