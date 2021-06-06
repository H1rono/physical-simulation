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

    public boolean contains_origin() {
        // http://www.slis.tsukuba.ac.jp/~fujisawa.makoto.fu/lecture/iml/text/gjk.html
        // https://trap.jp/post/198/
        // 単体上のある点
        Simplex smp = new Simplex();
        PVector origin = new PVector(0, 0);
        smp.point1.set(support(1, 0));
        // 単体上の点が原点かどうか判定
        if (smp.point1.x == 0 && smp.point1.y == 0) { return true; }
        PVector v1 = PVector.mult(smp.point1, -1);
        smp.point2.set(support(v1));
        if (v1.dot(smp.point2) < 0) { return false; }
        if (smp.point2.x == 0 && smp.point2.y == 0) { return true; }
        PVector v2 = new PVector(0, 0);
        // 時間制限つき
        for (int i = 0; i < 50; ++i) {
            // smp.point1, smp.point2を結ぶ直線と垂直な方向v2
            v2.set(smp.point2).sub(smp.point1);
            v2.set(v2.y, -v2.x);
            // v2はsmp.point1との内積が負のものを採用する
            if (v2.dot(smp.point1) > 0) { v2.mult(-1); }
            smp.point3.set(support(v2));
            if (smp.point3.x == 0 && smp.point3.y == 0) { return true; }
            if (v2.dot(smp.point3) < 0 || !smp.is_triangle()) { return false; }
            if (smp.contains(origin)) { return true; }
            // 原点から最も遠い点を削除
            float mp1 = smp.point1.magSq(), mp2 = smp.point2.magSq(), mp3 = smp.point3.magSq();
            float max_mag = max(mp1, max(mp2, mp3));
            if (max_mag == mp1) {
                smp.point1.set(smp.point3);
            } else if (max_mag == mp2) {
                smp.point2.set(smp.point3);
            } else /* max_mag == mp3 */ {
                // do nothing
            }
        }
        return false;
    }
}
