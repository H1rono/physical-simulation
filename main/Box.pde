class Box extends Rigid {
    //! 中心座標、速度
    private PVector center, velocity;
    //! 横幅、縦幅
    private float w_len, h_len, mass;
    //! 動くかどうか
    private boolean movable;

    public Box(PVector center, float w_len, float h_len, float mass, PVector velocity, boolean movable) {
        this.center = center;
        this.w_len = w_len;
        this.h_len = h_len;
        this.mass = mass;
        this.velocity = velocity;
        this.movable = movable;
    }

    @Override
    public PVector support(PVector point) {
        float w = w_len / 2, h = h_len / 2;
        float x = center.x + (w * point.x < 0 ? -w : w), y = center.y + (h * point.y < 0 ? -h : h);
        return new PVector(x, y);
    }

    @Override
    public PVector get_velocity() {
        return velocity;
    }

    @Override
    public void add_velocity(PVector delta_velocity) {
        if (!movable) {
            return;
        }
        velocity.add(delta_velocity);
    }

    @Override
    public void move(float delta_time) {
        if (!movable) {
            return;
        }
        PVector delta_center = PVector.mult(velocity, delta_time);
        center.add(delta_center);
    }

    @Override
    public boolean is_movable() {
        return movable;
    }

    @Override
    public float get_mass() {
        return mass;
    }

    @Override
    public float restitution_rate() {
        return 0.7;
    }

    @Override
    public float friction_rate() {
        return 0.7;
    }

    @Override
    public void draw(PApplet applet) {
        float x = center.x - w_len / 2, y = center.y - h_len / 2;
        applet.rect(x, y, w_len, h_len);
    }
}