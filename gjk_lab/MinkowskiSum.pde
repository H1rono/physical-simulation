/*
class MinkowskiSum extends Convex {
    private Convex cnv1, cnv2;

    public MinkowskiSum(Convex c1, Convex c2) {
        cnv1 = c1;
        cnv2 = c2;
    }

    @Override
    public PVector support(PVector point) {
        return cnv1.support(point).add(cnv2.support(point));
    }

    @Override
    public float min_x() {
        return cnv1.min_x() + cnv2.min_x();
    }

    @Override
    public float max_x() {
        return cnv1.max_x() + cnv2.max_x();
    }

    @Override
    public float min_y() {
        return cnv1.min_y() + cnv2.min_y();
    }

    @Override
    public float max_y() {
        return cnv1.max_y() + cnv2.max_y();
    }
}
*/
