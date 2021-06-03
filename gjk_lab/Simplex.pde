// 2次元単体、つまり三角形
class Simplex extends Convex {
    public PVector point1, point2, point3;

    public Simplex() {
        point1 = new PVector(0, 0);
        point2 = new PVector(0, 0);
        point3 = new PVector(0, 0);
    }

    public Simplex(PVector p1, PVector p2, PVector p3) {
        this();
        point1.set(p1);
        point2.set(p2);
        point3.set(p3);
    }

    public boolean is_triangle() {
        PVector edge1 = PVector.sub(point2, point1),
                edge2 = PVector.sub(point3, point1),
                normal1 = new PVector(edge1.y, -edge1.x);
        return edge2.dot(normal1) != 0;
    }

    public boolean contains(PVector point) {
        PVector edge1 = PVector.sub(point2, point1),  // point1からpoint2へのベクトル
                edge2 = PVector.sub(point3, point1),  // point1からpoint3へのベクトル
                p = PVector.sub(point, point1);      // point1からpoint へのベクトル
        PVector normal1 = new PVector(edge1.y, -edge1.x), // edge1の法線ベクトル
                normal2 = new PVector(edge2.y, -edge2.x); // edge2の法線ベクトル
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

    @Override
    public PVector support(PVector point) {
        PVector res = point1;
        if (res.dot(point) < point2.dot(point)) { res = point2; }
        if (res.dot(point) < point3.dot(point)) { res = point3; }
        return res.copy();
    }
}