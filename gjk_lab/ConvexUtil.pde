// Convexで使う関数群
public boolean contains_origin(Convex convex) {
    // http://www.slis.tsukuba.ac.jp/~fujisawa.makoto.fu/lecture/iml/text/gjk.html
    // https://trap.jp/post/198/
    // 単体上のある点
    Simplex smp = new Simplex();
    PVector origin = new PVector(0, 0);
    smp.point1.set(convex.support(1, 0));
    // 単体上の点が原点かどうか判定
    if (smp.point1.x == 0 && smp.point1.y == 0) { return true; }
    PVector v1 = PVector.mult(smp.point1, -1);
    smp.point2.set(convex.support(v1));
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
        smp.point3.set(convex.support(v2));
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

public boolean is_collide(Convex convex1, Convex convex2) {
    Convex minkowski_diff = new MinkowskiDiff(convex1, convex2);
    return contains_origin(minkowski_diff);
}

// GJKアルゴリズムを使用して、Convexの辺から原点へのベクトルで最短のものを求める
// ミンコフスキー差に対してこれを使うと接触法線が求まる
public PVector origin_normal(Convex convex) {
    // http://angra.blog31.fc2.com/blog-entry-115.html
    Simplex smp = new Simplex();
    PVector zero = new PVector(0, 0);
    smp.point1.set(convex.support(1, 0));
    if (smp.point1.x == 0 && smp.point1.y == 0) { return zero; }
    PVector vec = PVector.mult(smp.point1, -1);
    smp.point2.set(convex.support(vec));
    if (smp.point2.x == 0 && smp.point2.y == 0) { return zero; }
    PVector normal = new PVector(0, 0);
    boolean collide = false;

    for (int i = 0; i < 25; ++i) {
        vec.set(smp.point2).sub(smp.point1);
        vec.set(vec.y, -vec.x);
        if (vec.dot(smp.point1) > 0) { vec.mult(-1); }
        smp.point3.set(convex.support(vec));
        if (smp.point3.x == 0 && smp.point3.y == 0) { return zero; }
        normal.set(smp.contact(zero));
        if (smp.contains(zero)) {
            collide = true;
            break;
        }
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
    if (!collide) { return normal; }
    for (int i = 0; i < 25; ++i) {
        vec.set(smp.contact(zero));
        PVector new_point = convex.support(vec);
    }
}

public PVector contact_normal(Convex convex1, Convex convex2) {
    Convex diff = new MinkowskiDiff(convex1, convex2);
    return origin_normal(diff);
}
