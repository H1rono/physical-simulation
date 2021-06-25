class Constraint {
    public PVector axis;
    // 初期拘束力、拘束力下限、上限
    public float rhs, lower_lim, upper_lim;
    public SolverBody solver_bodyA, solver_bodyB;

    public Constraint(PVector axis, float rhs, float lower_lim, float upper_lim) {
        this.axis = axis;
        this.rhs = rhs;
        this.lower_lim = lower_lim;
        this.upper_lim = upper_lim;
    }

    public Constraint(PVector axis, float rhs) {
        this(axis, rhs, -Float.MAX_VALUE, 0);
    }

    public void eval(SolverBody solver_bodyA, SolverBody solver_bodyB) {
        float delta_impulse = rhs;
        PVector rel_delta_vel = PVector.sub(solver_bodyA.delta_velocity, solver_bodyB.delta_velocity);
        delta_impulse -= axis.dot(rel_delta_vel);
        delta_impulse = min(upper_lim, max(lower_lim, delta_impulse));
        solver_bodyA.delta_velocity.add(PVector.mult(axis, delta_impulse * solver_bodyA.mass_inv));
        solver_bodyB.delta_velocity.sub(PVector.mult(axis, delta_impulse * solver_bodyB.mass_inv));
    }
}
