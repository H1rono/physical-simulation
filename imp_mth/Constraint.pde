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
        this(axis, rhs, 0, Float.MAX_VALUE);
    }

    private void eval(SolverBody solver_bodyA, SolverBody solver_bodyB) {
        float delta_impulse = rhs;
        PVector rel_delta_vel = PVector.sub(solver_bodyA.delta_velocity, solver_bodyB.delta_velocity);
        delta_impulse -= axis.dot(rel_delta_vel);
        delta_impulse = min(upper_lim, max(lower_lim, delta_impulse));
        solver_bodyA.delta_velocity.add(PVector.mult(axis, delta_impulse * solver_bodyA.mass_inv));
        solver_bodyB.delta_velocity.sub(PVector.mult(axis, delta_impulse * solver_bodyB.mass_inv));
    }
}

public Constraint pair2constraint(Pair pair, float delta_time) {
    Rigid rigidA = pair.rigidA, rigidB = pair.rigidB;
    PVector velocityA = rigidA.get_velocity();
    PVector velocityB = rigidB.get_velocity();
    PVector relative_vel = PVector.sub(velocityA, velocityB);

    float friction = sqrt(rigidA.friction_rate() * rigidB.friction_rate());
    // 反発は新しいペアだけで起こる
    float restitution = pair.type == PairType.pair_new ? (rigidA.restitution_rate() + rigidB.restitution_rate()) * 0.5 : 0;

    PVector axis = new PVector(pair.contact_normal.x, pair.contact_normal.y).normalize();
    // 速度補正
    float rhs = -(1 + restitution) * axis.dot(relative_vel);
    // 位置補正
    rhs -= pair.contact_normal.mag() / delta_time;

    return new Constraint(axis, rhs);
}