// 2次元単体、つまり三角形
class Simplex {
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

    // 単体の辺上の点で、原点に最も近い点を求める
    public PVector contact(PVector point) {
        PVector normal_p = new PVector(-point.y, point.x);
        PVector v12 = PVector.sub(point1, point2), v23 = PVector.sub(point2, point3), v31 = PVector.sub(point3, point1);
        float dist1 = point1.magSq(), dist2 = point2.magSq(), dist3 = point3.magSq();
        float dist12 = pow(v12.dot(normal_p) + point1.dot(point2.y, -point2.x, 0), 2) / v12.magSq(),
            dist23   = pow(v23.dot(normal_p) + point2.dot(point3.y, -point3.x, 0), 2) / v23.magSq(),
            dist31   = pow(v31.dot(normal_p) + point3.dot(point1.y, -point1.x, 0), 2) / v31.magSq();
        float dist_min = min(
            min(dist1,  min(dist2,  dist3)),
            min(dist12, min(dist23, dist31))
        );

        if (dist_min == dist1) {
            return point1;
        } else if (dist_min == dist2) {
            return point2;
        } else if (dist_min == dist3) {
            return point3;
        } else if (dist_min == dist12) {
            PVector normal12 = new PVector(v12.y, -v12.x);
            normal12.normalize().mult(sqrt(dist12)).add(point);
            if (normal12.dot(point1) < 0) { normal12.mult(-1); }
            return normal12;
        } else if (dist_min == dist23) {
            PVector normal23 = new PVector(v23.y, -v23.x);
            normal23.normalize().mult(sqrt(dist23)).add(point);
            if (normal23.dot(point2) < 0) { normal23.mult(-1); }
            return normal23;
        }
        // else
        PVector normal31 = new PVector(v31.y, -v31.x);
        normal31.normalize().mult(sqrt(dist31)).add(point);
        if (normal31.dot(point3) < 0) { normal31.mult(-1); }
        return normal31;
    }
}