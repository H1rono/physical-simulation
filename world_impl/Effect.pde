class Effect {
    public PVector force, impulse;

    public Effect(PVector _force, PVector _impulse) {
        force = _force;
        impulse = _impulse;
    }

    public Effect() {
        this(new PVector(0, 0), new PVector(0, 0));
    }

    public String toString() {
        return "Effect(force=(" + force.x + ", " + force.y + "), impulse=(" + impulse.x + ", " + impulse.y + "))";
    }
}