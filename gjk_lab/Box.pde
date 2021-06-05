// Axis Aligned Bounding Box (AABB)
class Box {
    private PVector position;
    private float w_len, h_len;

    public Box(PVector pos, float w, float h) {
        position = new PVector(0, 0);
        position.set(pos);
        w_len = w;
        h_len = h;
    }

    public float min_x() {
        return min(position.x, position.x + w_len);
    }
    public float max_x() {
        return max(position.x, position.x + w_len);
    }

    public float min_y() {
        return min(position.y, position.y + h_len);
    }
    public float max_y() {
        return max(position.y, position.y + h_len);
    }

    public boolean is_collide(Box other) {
        boolean x_col = !(other.max_x() < this.min_x()) && !(this.max_x() < other.min_x()),
                y_col = !(other.max_y() < this.min_y()) && !(this.max_y() < other.min_y());
        return x_col && y_col;
    }
}