// Rigidのプロキシ
class SolverBody {
    // 速度差分
    public PVector delta_velocity;
    public float mass_inv;

    public SolverBody(PVector delta_velocity, float mass_inv) {
        this.delta_velocity = delta_velocity;
        this.mass_inv = mass_inv;
    }
}

SolverBody make_solver_body(Rigid rigid) {
    PVector delta_vel = new PVector(0, 0);
    float mass_inv = rigid.is_movable() ? 1 / rigid.get_mass() : 0;
    return new SolverBody(delta_vel, mass_inv);
}
