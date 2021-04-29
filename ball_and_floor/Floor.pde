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

    public void update(float delta_time) {
        // do nothing
    }

    public void draw() {
        line(0, this.height, width, this.height);
    }
}
