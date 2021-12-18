/** ボールを表現するクラス */
class Ball extends Rigid {
    private PVector center, velocity;
    private float mass, radius;
    private boolean movable;

    /**
     * 新たなBallオブジェクトを作成する
     * @param center 球の中心座標
     * @param velocity 球の初速度
     * @param mass 球の質量
     * @param radius 球の半径
     * @param movable 球が動くのかどうか
     */
    public Ball(PVector center, PVector velocity, float mass, float radius, boolean movable) {
        this.center = new PVector();
        this.velocity = new PVector();
        this.mass = mass;
        this.radius = radius;
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

        velocity.add(PVector.div(impulse, mass));
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
        PVector sub = PVector.sub(point, center);
        float mag = sub.mag();
        return mag <= radius ? new PVector(0, 0) : sub.mult((mag - radius) / mag);
    }

    @Override
    public boolean contains(float x, float y) {
        return pow(center.x - x, 2) + pow(center.y - y, 2) <= pow(radius, 2);
    }
    @Override
    public boolean contains(PVector point) {
        return center.dist(point) <= radius;
    }

    @Override
    public boolean is_collide(Rigid other) {
        return other.touching_vector(center).mag() <= radius;
    }

    @Override
    Effect effect_on(Rigid other, boolean new_collide) {
        PVector dir_e = touching_vector(other.get_center()).normalize().mult(1);
        PVector impulse = new PVector(0, 0);
        float this_m = this.get_mass(), other_m = other.get_mass();
        float this_v = dir_e.dot(velocity);
        float other_v = dir_e.dot(other.get_velocity());
        if (other_v - this_v < 0) {
            // 衝突した
            // 反発係数
            float repulsion = new_collide ? (repulsion_factor() + other.repulsion_factor()) / 2 : 0;
            float im = (
                (1 + repulsion/* 反発係数 */)
                * (movable ? this_m * other_m / (this_m + other_m) : other_m)
                * (this_v - other_v)
            );
            impulse.add(dir_e).mult(im);
        }
        return new Effect(this, other, impulse);
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
    public void receive_effect(Effect effect) {
        if (movable) {
            apply_impulse(effect.impulse);
        }
    }

    @Override
    public void update(float delta_time) {
        if (movable) {
            center.add(velocity.copy().mult(delta_time));
        }
    }

    @Override
    public void draw(PApplet applet) {
        applet.circle(center.x, center.y, radius * 2);
    }
}
