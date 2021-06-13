// Convexで使う関数群


public boolean contains_origin(Convex convex) {
    // http://www.slis.tsukuba.ac.jp/~fujisawa.makoto.fu/lecture/iml/text/gjk.html
    // https://trap.jp/post/198/
    Simplex smp = new Simplex();
    PVector origin = new PVector(0, 0);
    // 単体上のある点
    smp.vertex1.set(convex.support(1, 0));
    // 単体上の点が原点かどうか判定
    if (smp.vertex1.x == 0 && smp.vertex1.y == 0) { return true; }
    PVector v1 = PVector.mult(smp.vertex1, -1);
    smp.vertex2.set(convex.support(v1));
    if (v1.dot(smp.vertex2) < 0) { return false; }
    if (smp.vertex2.x == 0 && smp.vertex2.y == 0) { return true; }
    PVector v2 = new PVector(0, 0);
    // 時間制限つき
    for (int i = 0; i < 50; ++i) {
        // smp.vertex1, smp.vertex2を結ぶ直線と垂直な方向v2
        v2.set(smp.vertex2).sub(smp.vertex1);
        v2.set(v2.y, -v2.x);
        // v2はsmp.vertex1との内積が負のものを採用する
        if (v2.dot(smp.vertex1) > 0) { v2.mult(-1); }
        smp.vertex3.set(convex.support(v2));
        if (smp.vertex3.x == 0 && smp.vertex3.y == 0) { return true; }
        if (v2.dot(smp.vertex3) < 0 || !smp.is_triangle()) { return false; }
        if (smp.contains(origin)) { return true; }
        // 原点から最も遠い点を削除
        float mp1 = smp.vertex1.magSq(), mp2 = smp.vertex2.magSq(), mp3 = smp.vertex3.magSq();
        float max_mag = max(mp1, max(mp2, mp3));
        if (max_mag == mp1) {
            smp.vertex1.set(smp.vertex3);
        } else if (max_mag == mp2) {
            smp.vertex2.set(smp.vertex3);
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
    smp.vertex1.set(convex.support(1, 0));
    if (smp.vertex1.x == 0 && smp.vertex1.y == 0) { return zero; }
    PVector vec = PVector.mult(smp.vertex1, -1);
    smp.vertex2.set(convex.support(vec));
    if (smp.vertex2.x == 0 && smp.vertex2.y == 0) { return zero; }
    PVector normal = new PVector(0, 0);
    boolean collide = false;

    for (int i = 0; i < 25; ++i) {
        vec.set(smp.vertex2).sub(smp.vertex1);
        vec.set(vec.y, -vec.x);
        if (vec.dot(smp.vertex1) > 0) { vec.mult(-1); }
        smp.vertex3.set(convex.support(vec));
        if (smp.vertex3.x == 0 && smp.vertex3.y == 0) { return zero; }
        normal.set(smp.contact_normal(zero));
        if (smp.contains(zero)) {
            collide = true;
            break;
        }
        // 原点から最も遠い点を削除
        float mp1 = smp.vertex1.magSq(), mp2 = smp.vertex2.magSq(), mp3 = smp.vertex3.magSq();
        float max_mag = max(mp1, max(mp2, mp3));
        if (max_mag == mp1) {
            smp.vertex1.set(smp.vertex3);
        } else if (max_mag == mp2) {
            smp.vertex2.set(smp.vertex3);
        } else /* max_mag == mp3 */ {
            // do nothing
        }
    }
    if (!collide) { return normal; }
    Polygon polygon = new Polygon();
    polygon.add_vertex(smp.vertex1);
    polygon.add_vertex(smp.vertex2);
    polygon.add_vertex(smp.vertex3);
    for (int i = 0; i < 25; ++i) {
        vec.set(polygon.contact_normal(zero)).mult(-1);
        polygon.add_vertex(convex.support(vec));
    }
    return vec;
}

// 接触法線
public PVector contact_normal(Convex convex1, Convex convex2) {
    Convex diff = new MinkowskiDiff(convex1, convex2);
    return origin_normal(diff);
}

ConvexRelation makeRelation(Convex convex1, Convex convex2) {
    // http://angra.blog31.fc2.com/blog-entry-115.html
    ConvexRelation relation = new ConvexRelation(convex1, convex2, false, new PVector(0, 0));
    Convex minkowski_diff = new MinkowskiDiff(convex1, convex2);
    Simplex smp = new Simplex();
    PVector zero = new PVector(0, 0);
    smp.vertex1.set(minkowski_diff.support(1, 0));
    if (smp.vertex1.x == 0 && smp.vertex1.y == 0) {
        relation.collision = true;
        return relation;
    }
    PVector vec = PVector.mult(smp.vertex1, -1);
    smp.vertex2.set(minkowski_diff.support(vec));
    if (smp.vertex2.x == 0 && smp.vertex2.y == 0) {
        relation.collision = true;
        return relation;
    }

    for (int i = 0; i < 25; ++i) {
        vec.set(smp.vertex2).sub(smp.vertex1);
        vec.set(vec.y, -vec.x);
        if (vec.dot(smp.vertex1) > 0) { vec.mult(-1); }
        smp.vertex3.set(minkowski_diff.support(vec));
        if (smp.vertex3.x == 0 && smp.vertex3.y == 0) {
            relation.collision = true;
            return relation;
        }
        relation.contact_normal.set(smp.contact_normal(zero));
        if (smp.contains(zero)) {
            relation.collision = true;
            break;
        }
        // 原点から最も遠い点を削除
        float mp1 = smp.vertex1.magSq(), mp2 = smp.vertex2.magSq(), mp3 = smp.vertex3.magSq();
        float max_mag = max(mp1, max(mp2, mp3));
        if (max_mag == mp1) {
            smp.vertex1.set(smp.vertex3);
        } else if (max_mag == mp2) {
            smp.vertex2.set(smp.vertex3);
        } else /* max_mag == mp3 */ {
            // do nothing
        }
    }
    if (!relation.collision) { return relation; }
    relation.contact_normal.set(vec);
    Polygon polygon = new Polygon();
    polygon.add_vertex(smp.vertex1);
    polygon.add_vertex(smp.vertex2);
    polygon.add_vertex(smp.vertex3);
    for (int i = 0; i < 50; ++i) {
        relation.contact_normal.set(polygon.contact_normal(zero)).mult(-1);
        polygon.add_vertex(minkowski_diff.support(relation.contact_normal));
    }
    return relation;
}