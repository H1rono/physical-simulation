class Ball extends Rigid {
    //! 中心座標
    private PVector center;

    //! 並進運動の速度
    private PVector velocity;

    //! 半径
    private float radius;

    //! 質量
    private float mass;

    //! 球が動くのかどうか。動かない場合、`add_velocity`メソッド、`move`メソッドによって何も変化しなくなる。
    private boolean movable;

    /**
     * コンストラクタ
     * @param center 中心座標
     * @param radius 半径
     * @param mass 質量
     * @param velocity 並進運動の速度
     * @param movable 動くのかどうか
     */
    public Ball(PVector center, float radius, float mass, PVector velocity, boolean movable) {
        this.center = center;
        this.radius = radius;
        this.mass = mass;
        this.movable = movable;
        this.velocity = velocity;
    }

    @Override
    public PVector support(PVector point) {
        return PVector.add(center, point.copy().normalize().mult(radius));
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
        return 1;
    }

    @Override
    public float friction_rate() {
        return 0;
    }

    @Override
    public void draw(PApplet applet) {
        applet.circle(center.x, center.y, radius * 2);
    }
}