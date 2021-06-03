class Rectangle extends Convex implements Drawable {
    private PVector position;
    private float w_len, h_len;

    public Rectangle(PVector pos, float w, float h) {
        position = new PVector(0, 0);
        position.set(pos);
        w_len = w;
        h_len = h;
    }

    public PVector get_position() { return position; }
    public void set_position(PVector pos) { position.set(pos); }

    public float get_x() { return position.x; }
    public void set_x(float x) { position.x = x; }

    public float get_y() { return position.y; }
    public void set_y(float y) { position.y = y; }

    public float get_width() { return w_len; }
    public void set_width(float w) { w_len = w; }

    public float get_height() { return h_len; }
    public void set_height(float h) { h_len = h; }

    @Override
    public PVector support(PVector point) {
        float w = 0, h = 0;
        float d_lu = point.dot(position),
            d_ru = point.dot(position.x + w_len, position.y, 0),
            d_ld = point.dot(position.x, position.y + h_len, 0),
            d_rd = point.dot(position.x + h_len, position.y + h_len, 0);
        float d_max = max(max(d_lu, d_ru), max(d_ld, d_rd));
        if (d_max == d_lu) {
            return position.copy();
        } else if (d_max == d_ru) {
            return position.copy().add(w_len, 0);
        } else if (d_max == d_ld) {
            return position.copy().add(0, h_len);
        }
        return position.copy().add(w_len, h_len);
    }

    @Override
    public void draw() {
        rect(position.x, position.y, w_len, h_len);
    }
}