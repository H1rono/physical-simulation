// 剛体
abstract class Rigid extends Convex {
    abstract public boolean is_movable();

    abstract public PVector get_center();
    abstract public void set_center(PVector _center);
    abstract public void add_center(PVector _center);
    
    abstract public PVector get_velocity();
    abstract public void set_velocity(PVector _velocity);
    abstract public void add_velocity(PVector _velocity);
    //abstract public PVector get_accelaration();
    
    abstract public float get_mass();

    abstract public void set_force(PVector _force);
    abstract public void add_force(PVector _force);

    abstract public void reset_impulse();
    abstract public void add_impulse(PVector _impulse);
    abstract public void apply_impulse();
    
    abstract public void update(float delta_time);
}
