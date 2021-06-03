class CnvAddVec extends Convex {
    private PVector vec;
    private Convex cnv;

    public CnvAddVec(PVector v, Convex c) {
        vec = v;
        cnv = c;
    }

    @Override
    public PVector support(PVector p) {
        return cnv.support(p).add(vec);
    }
}