abstract class Rigid implements Convex, Drawable {
    private int id = 0;

    public abstract PVector get_velocity();
    public abstract void add_velocity(PVector delta_velocity);
    public abstract void move(float delta_time);
    public abstract boolean is_movable();
    public abstract float get_mass();

    public float get_mass_inv() {
        return is_movable() ? 1 / get_mass() : 0;
    }

    public abstract float restitution_rate();
    public abstract float friction_rate();

    public int get_id() {
        return id;
    }

    public void set_id(int id) {
        this.id = id;
    }
}