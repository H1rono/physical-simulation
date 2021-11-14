// 剛体
abstract class Rigid extends Convex {
    abstract public boolean is_movable();

    abstract public float friction_rate();
    abstract public float restitution_rate();

    abstract public PVector get_center();
    abstract public PVector get_velocity();
    abstract public PVector get_accelaration();

    abstract public void add_velocity(PVector velocity);

    abstract public void update_center(float delta_time);

    abstract public float get_mass();

    abstract public PVector get_force();
    abstract public void reset_force(PVector force);
    abstract public void add_force(PVector force);

    abstract public void reset_impulse(PVector impulse);
    abstract public void add_impulse(PVector impulse);

    abstract public void update(float delta_time);
}
