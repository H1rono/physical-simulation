class Circle extends Convex implements Drawable {
    private PVector center;
    private float radius;

    public Circle(PVector c, float rad) {
        center = new PVector(0, 0);
        center.set(c);
        radius = rad;
    }

    public float get_radius() {
        return radius;
    }

    public void set_center(float r) {
        radius = r;
    }

    public PVector get_center() {
        return center;
    }

    public void set_center(PVector c) {
        center.set(c);
    }

    public PVector set_center(float x, float y) {
        return center.set(x, y);
    }

    public float min_x() {
        return center.x - radius;
    }
    public float max_x() {
        return center.x + radius;
    }
    public float min_y() {
        return center.y - radius;
    }
    public float max_y() {
        return center.y + radius;
    }

    @Override
    public PVector support(PVector point) {
        float m = point.mag();
        PVector d = PVector.mult(point, radius / m);
        return PVector.add(center, d);
    }

    @Override
    public void draw() {
        circle(center.x, center.y, radius * 2);
    }
}