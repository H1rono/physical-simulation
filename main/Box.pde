/** 箱を表現するクラス */
class Box extends Rigid {
    private PVector center, velocity;
    private float mass, w_len, h_len; // w_len: 横幅、h_len: 縦幅
    private boolean movable;

    /**
     * 新たなBoxオブジェクトを作成する
     * @param center 箱の中心座標
     * @param velocity 箱の初速度
     * @param mass 箱の質量
     * @param w_len 箱の横幅
     * @param h_len 箱の縦幅
     * @param movable 箱が動くのかどうか
     */
    public Box(PVector center, PVector velocity, float mass, float w_len, float h_len, boolean movable) {
        this.center = new PVector();
        this.velocity = new PVector();
        this.mass = mass;
        this.w_len = w_len;
        this.h_len = h_len;
        this.movable = movable;
        this.center.set(center);
        this.velocity.set(velocity);
    }

    @Override
    public PVector get_center() {
        return center;
    }

    @Override
    public PVector get_velocity() {
        return velocity;
    }

    @Override
    public void apply_impulse(PVector impulse) {
        if (movable){
            velocity.add(PVector.div(impulse, mass));
        }
    }

    @Override
    public float get_mass() {
        return mass;
    }

    @Override
    public boolean is_movable() {
        return movable;
    }

    @Override
    public PVector touching_vector(PVector point) {
        float w = w_len / 2.0f, h = h_len / 2.0f;
        float x_l = center.x - w, x_r = center.x + w;
        float y_l = center.y - h, y_h = center.y + h;
        return new PVector(
            point.x < x_l ? x_l - point.x : point.x <= x_r ? 0 : x_r - point.x,
            point.y < y_l ? y_l - point.y : point.y <= y_h ? 0 : y_h - point.y
        );
    }

    // 座標を含んでいるか判定する関数
    @Override
    public boolean contains(float x, float y) {
        float w = w_len / 2.0f, h = h_len / 2.0f;
        return (
            center.x - w <= x && x <= center.x + w
            && center.y - h <= y && y <= center.y + h
        );
    }
    @Override
    public boolean contains(PVector point) {
        PVector c = PVector.sub(center, point);
        return abs(c.x) <= w_len / 2.0f && abs(c.y) <= h_len;
    }

    // 衝突判定の関数
    @Override
    public boolean is_collide(Rigid other) {
        PVector touching = other.touching_vector(center);
        return (
            abs(touching.x) <= w_len / 2
            && abs(touching.y) <= h_len / 2
        );
    }

    @Override
    public Effect effect_on(Rigid other, boolean new_collide) {
        PVector dir_e = touching_vector(other.get_center()).normalize().mult(-1);
        PVector impulse = new PVector(0, 0);
        float this_m = this.get_mass(), other_m = other.get_mass();
        float this_v = dir_e.dot(velocity);
        float other_v = dir_e.dot(other.get_velocity());
        if (other_v - this_v < 0) {
            // 衝突した
            // 反発係数
            float repulsion = new_collide ? (repulsion_factor() + other.repulsion_factor()) / 2 : 0;
            float im = (
                (1 + repulsion)
                * (movable ? this_m * other_m / (this_m + other_m) : other_m)
                * (this_v - other_v)
            );
            impulse = PVector.mult(dir_e, im);
        }
        return new Effect(this, other, impulse);
    }

    @Override
    public void receive_effect(Effect effect) {
        if (movable) {
            apply_impulse(effect.impulse);
        }
    }

    @Override
    public float repulsion_factor() {
        return 1.0f;
    }

    @Override
    public float friction_factor() {
        return 0.0f;
    }

    @Override
    public void update(float delta_time) {
        if (movable) {
            center.add(velocity.copy().mult(delta_time));
        }
    }

    @Override
    public void draw(PApplet applet) {
        applet.rect(center.x - w_len / 2, center.y - h_len / 2, w_len, h_len);
    }
}
