// 凸包
abstract class Convex {
    public abstract float min_x();
    public abstract float max_x();
    public abstract float min_y();
    public abstract float max_y();

    public abstract PVector support(PVector direction);

    public PVector support(float x, float y) {
        return support(new PVector(x, y));
    }

    // aabb (axis-aligned bounding box) で衝突判定
    public boolean aabb_collide(Convex other) {
        boolean x_col = !(other.max_x() < this.min_x()) && !(this.max_x() < other.min_x()),
                y_col = !(other.max_y() < this.min_y()) && !(this.max_y() < other.min_y());
        return x_col && y_col;
    }
}
