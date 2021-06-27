class MinkowskiDiff implements Convex {
    // convex_a - convex_b
    private Convex convex_a, convex_b;

    public MinkowskiDiff(Convex convex_a, Convex convex_b) {
        this.convex_a = convex_a;
        this.convex_b = convex_b;
    }

    public PVector support(PVector point) {
        PVector sup_a = convex_a.support(point);
        PVector sup_b = convex_b.support(PVector.mult(point, -1));
        return sup_a.sub(sup_b);
    }
}