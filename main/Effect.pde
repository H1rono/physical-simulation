class Effect {
    public PVector impulse;
    public Rigid provider, receiver;

    public Effect(Rigid provider, Rigid receiver, PVector impulse) {
        this.provider = provider;
        this.receiver = receiver;
        this.impulse = impulse;
    }

    public void realize() {
        receiver.receive_effect(this);
    }

    public String toString() {
        return "Effect(" + provider.get_id() + ", " + receiver.get_id() + ", " + impulse + ")";
    }
}