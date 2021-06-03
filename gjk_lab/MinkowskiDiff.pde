class MinkowskiDiff extends Convex {
    private Convex cnv1, cnv2;

    public MinkowskiDiff(Convex c1, Convex c2) {
        cnv1 = c1;
        cnv2 = c2;
    }

    public PVector support(PVector point) {
        return cnv1.support(point).sub(cnv2.support(PVector.mult(point, -1)));
    }
}