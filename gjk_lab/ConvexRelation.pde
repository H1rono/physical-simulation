class ConvexRelation {
    public Convex convex1, convex2;
    public boolean collision;
    public PVector contact_normal;

    public ConvexRelation(Convex cnv1, Convex cnv2, boolean col, PVector normal) {
        convex1 = cnv1;
        convex2 = cnv2;
        collision = col;
        contact_normal = normal;
    }
}
