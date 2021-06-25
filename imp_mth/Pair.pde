import java.util.Optional;

class Pair {
    public PairType type;
    // 貫通深度
    public PVector contact_normal;
    // merge_pairsで使う
    public int idA, idB;
    public Optional<Constraint> constraint_contact, constraint_friction;

    public Pair(PairType type, PVector contact_normal, int idA, int idB, Constraint cons_cont, Constraint cons_fric) {
        this.type = type;
        this.contact_normal = contact_normal;
        this.idA = idA;
        this.idB = idB;
        constraint_contact = Optional.ofNullable(cons_cont);
        constraint_friction = Optional.ofNullable(cons_fric);
    }

    public Pair(PairType type, PVector contact_normal, int idA, int idB) {
        this(type, contact_normal, idA, idB, null, null);
    }
}

public Pair make_pair(Rigid rigidA, Rigid rigidB, int idA, int idB) {
    // http://angra.blog31.fc2.com/blog-entry-115.html
    // https://trap.jp/post/198/
    Pair pair = new Pair(PairType.not_collide, new PVector(0, 0), idA, idB);
    Convex minkowski_diff = new MinkowskiDiff(rigidA, rigidB);

    // GJK法
    Simplex smp = new Simplex();
    PVector zero = new PVector(0, 0);
    // smp.vertex1はミンコフスキー差上の適当な点
    smp.vertex1.set(minkowski_diff.support(1, 0));
    // サポート写像が0ベクトル => ミンコフスキー差が原点を含む => 衝突している
    if (smp.vertex1.x == 0 && smp.vertex1.y == 0) {
        pair.type = PairType.pair_new;
        return pair;
    }
    // 逆ベクトルに同様の操作をする
    // vecは一時的な変数
    PVector vec = PVector.mult(smp.vertex1, -1);
    smp.vertex2.set(minkowski_diff.support(vec));
    if (smp.vertex2.x == 0 && smp.vertex2.y == 0) {
        pair.type = PairType.pair_new;
        return pair;
    }
    // 反復部分を回数制限付きで実行
    // 制限を緩めるとより時間がかかるようになるが、精度が上がる
    for (int i = 0; i < 100; ++i) {
        // vec = PVector.sub(smp.vertex2, smp.vertex1)と同意
        vec.set(smp.vertex2).sub(smp.vertex1);
        // 法線ベクトル
        vec.set(vec.y, -vec.x);
        // 法線ベクトルは2つあるので、smp.vertex1とsmp.vertex2の線分から原点を向いているものを採用
        if (vec.dot(smp.vertex1) > 0) { vec.mult(-1); }
        smp.vertex3.set(minkowski_diff.support(vec));
        if (smp.vertex3.x == 0 && smp.vertex3.y == 0) {
            pair.type = PairType.pair_new;
            return pair;
        }
        pair.contact_normal.set(smp.contact_normal(zero));
        if (smp.contains(zero)) {
            pair.type = PairType.pair_new;
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
    if (pair.type == PairType.not_collide) { return pair; }

    // EPA法
    Polygon polygon = new Polygon();
    polygon.add_vertex(smp.vertex1);
    polygon.add_vertex(smp.vertex2);
    polygon.add_vertex(smp.vertex3);
    for (int i = 0; i < 100; ++i) {
        vec.set(polygon.contact_normal(zero));
        polygon.add_vertex(minkowski_diff.support(vec));
        if (vec.x == pair.contact_normal.x && vec.y == pair.contact_normal.y) { break; }
        pair.contact_normal.set(vec);
    }
    return pair;
}