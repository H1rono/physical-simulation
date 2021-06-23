class MinkowskiDiff extends Convex {
    // cnv1 - cnv2
    private Convex cnv1, cnv2;

    public MinkowskiDiff(Convex _cnv1, Convex _cnv2) {
        cnv1 = _cnv1;
        cnv2 = _cnv2;
    }

    public PVector support(PVector point) {
        return cnv1.support(point).sub(cnv2.support(PVector.mult(point, -1)));
    }

    @Override
    public float min_x() {
        return min(
            cnv1.min_x() - cnv2.max_x(),
            cnv1.max_x() - cnv2.min_x()
        );
    }

    @Override
    public float max_x() {
        return max(
            cnv1.min_x() - cnv2.max_x(),
            cnv1.max_x() - cnv2.min_x()
        );
    }

    @Override
    public float min_y() {
        return min(
            cnv1.min_y() - cnv2.max_y(),
            cnv1.max_y() - cnv2.min_y()
        );
    }

    @Override
    public float max_y() {
        return max(
            cnv1.min_y() - cnv2.max_y(),
            cnv1.max_y() - cnv2.min_y()
        );
    }
}
