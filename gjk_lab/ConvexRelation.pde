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

ConvexRelation make_relation(Convex convex1, Convex convex2) {
    // http://angra.blog31.fc2.com/blog-entry-115.html
    ConvexRelation relation = new ConvexRelation(convex1, convex2, false, new PVector(0, 0));
    Convex minkowski_diff = new MinkowskiDiff(convex1, convex2);

    // GJK法
    Simplex smp = new Simplex();
    PVector zero = new PVector(0, 0);
    // smp.vertex1はミンコフスキー差上の適当な点
    smp.vertex1.set(minkowski_diff.support(1, 0));
    // サポート写像が0ベクトル => ミンコフスキー差が原点を含む => 衝突している
    if (smp.vertex1.x == 0 && smp.vertex1.y == 0) {
        relation.collision = true;
        return relation;
    }
    // 逆ベクトルに同様の操作をする
    // vecは一時的な変数
    PVector vec = PVector.mult(smp.vertex1, -1);
    smp.vertex2.set(minkowski_diff.support(vec));
    if (smp.vertex2.x == 0 && smp.vertex2.y == 0) {
        relation.collision = true;
        return relation;
    }
    // 反復部分を回数制限付きで実行
    // 制限を緩めるとより時間がかかるようになるが、精度が上がる
    for (int i = 0; i < 25; ++i) {
        // vec = PVector.sub(smp.vertex2, smp.vertex1)と同意
        vec.set(smp.vertex2).sub(smp.vertex1);
        // 法線ベクトル
        vec.set(vec.y, -vec.x);
        // 法線ベクトルは2つあるので、smp.vertex1とsmp.vertex2の線分から原点を向いているものを採用
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
        } /* max_mag == mp3 : do nothing */
    }
    if (!relation.collision) { return relation; }

    // EPA法
    Polygon polygon = new Polygon();
    polygon.add_vertex(smp.vertex1);
    polygon.add_vertex(smp.vertex2);
    polygon.add_vertex(smp.vertex3);
    for (int i = 0; i < 50; ++i) {
        vec.set(polygon.contact_normal(zero)).mult(-1);
        polygon.add_vertex(minkowski_diff.support(relation.contact_normal));
        if (vec.x == relation.contact_normal.x && vec.y == relation.contact_normal.y) { break; }
        relation.contact_normal.set(vec);
    }
    return relation;
}
