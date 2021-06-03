class MinkowskiSum extends Convex {
    private Convex cnv1, cnv2;

    public MinkowskiSum(Convex c1, Convex c2) {
        cnv1 = c1;
        cnv2 = c2;
    }

    public PVector support(PVector point) {
        return cnv1.support(point).add(cnv2.support(point));
    }
}