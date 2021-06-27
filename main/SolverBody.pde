// Rigidのプロキシ
class SolverBody {
    // 速度差分
    public PVector delta_velocity;
    public Rigid ref_rigid;
    public float mass_inv;

    public SolverBody(Rigid ref_rigid, PVector delta_velocity, float mass_inv) {
        this.ref_rigid = ref_rigid;
        this.delta_velocity = delta_velocity;
        this.mass_inv = mass_inv;
    }
}

SolverBody make_solver_body(Rigid rigid) {
    PVector delta_vel = new PVector(0, 0);
    float mass_inv = rigid.get_mass_inv();
    return new SolverBody(ref_rigid, delta_vel, mass_inv);
}