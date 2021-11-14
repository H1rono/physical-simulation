// 2次元単体、つまり三角形
class Simplex {
    public PVector vertex1, vertex2, vertex3;

    public Simplex() {
        vertex1 = new PVector(0, 0);
        vertex2 = new PVector(0, 0);
        vertex3 = new PVector(0, 0);
    }

    public Simplex(PVector p1, PVector p2, PVector p3) {
        this();
        vertex1.set(p1);
        vertex2.set(p2);
        vertex3.set(p3);
    }

    public boolean is_triangle() {
        PVector edge1 = PVector.sub(vertex2, vertex1),
                edge2 = PVector.sub(vertex3, vertex1),
                normal1 = new PVector(edge1.y, -edge1.x);
        return edge2.dot(normal1) != 0;
    }

    public boolean contains(PVector point) {
        PVector edge1 = PVector.sub(vertex2, vertex1),  // vertex1からvertex2へのベクトル
                edge2 = PVector.sub(vertex3, vertex1),  // vertex1からvertex3へのベクトル
                p = PVector.sub(point, vertex1);      // vertex1からpoint へのベクトル
        PVector normal1 = new PVector(edge1.y, -edge1.x), // edge1の法線ベクトル
                normal2 = new PVector(edge2.y, -edge2.x); // edge2の法線ベクトル
        // 内積たち
        float   e1n2 = edge1.dot(normal2),
                e2n1 = edge2.dot(normal1),
                p_n2 = p.dot(normal2),
                p_n1 = p.dot(normal1);
        if (e1n2 == 0) {
            // edge1とnormal2が垂直
            // つまり、単体の3頂点が1直線上にある
            return false;
        }
        // p = m1 * edge1 + m2 * edge2
        float m1 = p_n2 / e1n2, m2 = p_n1 / e2n1;
        return m1 > 0 && m2 > 0 && m1 + m2 <= 1;
    }

    // 原点から単体の辺上まで最短のベクトル
    public PVector contact(PVector point) {
        return contact_normal(new PVector(0, 0));
    }

    // pointから単体の辺上まで最短のベクトル
    public PVector contact_normal(PVector point) {
        PVector vertices[] = new PVector[] {vertex1, vertex2, vertex3};
        PVector vert1 = PVector.sub(vertices[0], point),
                vert2 = PVector.sub(vertices[2], point);
        PVector v21 = PVector.sub(vert1, vert2); // vert2 -> vert1
        float ratio = Math.max(0, Math.min(1,
            vert1.dot(v21) / v21.magSq()
        ));
        // result = vert1 + ratio * (vert2 - vert1)    <---- if 0 <= ratio <= 1
        // result = vert1                              <---- if ratio < 0
        // result = vert2                              <---- if 1 < ratio
        PVector result = PVector.mult(vert1, 1 - ratio).add(PVector.mult(vert2, ratio));
        for (int i = 1; i < 3; ++i) {
            vert2.set(vert1);
            vert1.set(PVector.sub(vertices[i], point));
            v21.set(vert1).sub(vert2);
            ratio = Math.max(0, Math.min(1, vert1.dot(v21) / v21.magSq()));
            PVector res = PVector.mult(vert1, 1 - ratio).add(PVector.mult(vert2, ratio));
            if (res.magSq() < result.magSq()) {
                result.set(res);
            }
        }
        return result;
    }
}