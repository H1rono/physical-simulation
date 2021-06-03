Circle mouse, center;

void draw_circle(Circle c) {
    PVector cent = c.get_center();
    circle(cent.x, cent.y, c.get_radius() * 2);
}

PVector get_mouse() {
    return new PVector(
        max(0, min(width, mouseX)),
        max(0, min(height, mouseY))
    );
}

void setup() {
    size(720, 720);
    mouse = new Circle(new PVector(0, 0), 50);
    center = new Circle(new PVector(width / 2, height / 2), 50);
}

void draw() {
    background(255);
    mouse.set_center(get_mouse());
    if (new MinkowskiDiff(mouse, center).contains_origin()) {
        // 衝突
        fill(255, 0, 0);
    } else {
        fill(255);
    }
    draw_circle(center);
    draw_circle(mouse);
}