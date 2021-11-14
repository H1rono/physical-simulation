class Constraint {
    public PVector axis;
    // 初期拘束力、拘束式の分母、拘束力下限、上限
    public float rhs, jac_diag_inv, lower_lim, upper_lim;
    public SolverBody solver_body_a, solver_body_b;

    public Constraint(PVector axis, float rhs, float jac_diag_inv, float lower_lim, float upper_lim) {
        this.axis = axis;
        this.rhs = rhs;
        this.jac_diag_inv = jac_diag_inv;
        this.lower_lim = lower_lim;
        this.upper_lim = upper_lim;
    }

    public Constraint(PVector axis, float rhs, float jac_diag_inv) {
        this(axis, rhs, jac_diag_inv, -Float.MAX_VALUE, 0);
    }

    public void eval(SolverBody solver_body_a, SolverBody solver_body_b) {
        float delta_impulse = rhs;
        PVector rel_delta_vel = PVector.sub(solver_body_a.delta_velocity, solver_body_b.delta_velocity);
        delta_impulse -= jac_diag_inv * axis.dot(rel_delta_vel);
        delta_impulse = min(upper_lim, max(lower_lim, delta_impulse));
        solver_body_a.delta_velocity.add(PVector.mult(axis, delta_impulse * solver_body_a.mass_inv));
        solver_body_b.delta_velocity.sub(PVector.mult(axis, delta_impulse * solver_body_b.mass_inv));
    }
}