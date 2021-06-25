class Spring implements ExternalFactor, Drawable {
    private float natural_length;
    private WorldElement connect_elemA, connect_elemB;

    public Spring(float natural_length, WorldElement elemA, WorldElement elemB) {
        this.natural_length = natural_length;
        connect_elemA = elemA;
        connect_elemB = elemB;
    }

    @Override
    public void update() {
        Convex minkowski_diff = new MinkowskiDiff(connect_elemA, connect_elemB);

    }

    @Override
    public void apply() {}

    @Override
    public void draw() {}
}