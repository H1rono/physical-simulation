// 剛体
abstract class Rigid extends Convex {
    abstract public PVector get_center();
    abstract public PVector get_velocity();
    abstract public PVector get_accelaration();
    abstract public float get_mass();
    abstract public void reset_force(PVector force);
    abstract public void add_force(PVector force);
    abstract public void reset_impulse(PVector impulse);
    abstract public void add_impulse(PVector impulse);
    abstract public void update(float delta_time);
}
