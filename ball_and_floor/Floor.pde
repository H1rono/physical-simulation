public class Floor {
    public float height;

    public Floor(float _height) {
        this.height = _height;
    }

    public boolean is_collide(Floor floor) {
        return false;
    }

    public boolean is_collide(Ball ball) {
        return abs(this.height - ball.position.y) < ball.radius;
    }

    public Effect effect_on(Ball ball) {
        PVector vel = ball.velocity, impulse = new PVector(0, 0);
        float ydif = ball.position.y - this.height;
        float vx = vel.x, vy = vel.y;
        if (ydif * vy < 0) {
            // 衝突している
            impulse.y = ball.mass * -vy * (1 + 1/* 反発係数 */);
        }

        PVector b_force = ball.get_force(), force = new PVector(0, 0);
        if (ydif * b_force.y < 0) {
            force.y = -b_force.y;
            // friction
            float vsign = vx == 0 ? 1 : vx / abs(vx);
            if (vx != 0) {
                force.x = abs(b_force.y) * 0.5/* 動摩擦係数 */ * -vsign;
            } else {
                float fsign = b_force.x == 0 ? 1 : b_force.x / abs(b_force.x);
                force.x = -fsign * min(abs(force.x), abs(b_force.y) * 1/* 静止摩擦係数 */);
            }
        }
        return new Effect(force, impulse);
    }

    public Effect effect_on(Floor floor) {
        return new Effect();
    }

    public void add_effect(Effect effect) {
        // do nothing
    }

    public void update(float delta_time) {
        // do nothing
    }

    public void draw() {
        line(0, this.height, width, this.height);
    }
}
