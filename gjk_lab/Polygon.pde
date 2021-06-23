// 多角形
// 凹みを許し、できるだけ辺同士が交差しないように頂点を管理する

class Polygon implements Drawable {
    private List<PVector> vertices;

    public Polygon() {
        vertices = new ArrayList<PVector>();
    }

    public ListIterator<PVector> vertex_iterator() {
        return vertices.listIterator();
    }

    public void add_vertex(PVector vert) {
        int num_vert = vertices.size();
        if (num_vert < 3) {
            vertices.add(vert);
            return;
        }
        PVector vert_ = vertices.get(0),
                unit1 = PVector.sub(vert_, vert).normalize(),
                unit2 = PVector.sub(vertices.get(num_vert - 1), vert).normalize();
        if (vert_.x == vert.x && vert_.y == vert.y) { return; }
        float cos_min = unit1.dot(unit2);
        int insert_index = num_vert;
        for (int i = 1; i < num_vert; ++i) {
            unit2 = unit1;
            vert_ = vertices.get(i);
            if (vert_.x == vert.x && vert_.y == vert.y) { return; }
            unit1 = PVector.sub(vert_, vert).normalize();
            float cos_ = unit1.dot(unit2);
            if (cos_ < cos_min) {
                cos_min = cos_;
                insert_index = i;
            }
        }
        vertices.add(insert_index, vert);
    }

    // pointから多角形の辺上まで最短のベクトル
    public PVector contact_normal(PVector point) {
        int num_vert = vertices.size();
        if (num_vert == 0) { return new PVector(0, 0); }
        if (num_vert == 1) { return PVector.sub(vertices.get(0), point); }
        PVector vert1 = PVector.sub(vertices.get(0), point),
                vert2 = PVector.sub(vertices.get(num_vert - 1), point);
        PVector v21 = PVector.sub(vert1, vert2); // vert2 -> vert1
        float ratio = Math.max(0, Math.min(1,
            vert1.dot(v21) / v21.magSq()
        ));
        // result = vert1 + ratio * (vert2 - vert1)    <---- if 0 <= ratio <= 1
        // result = vert1                              <---- if ratio < 0
        // result = vert2                              <---- if 1 < ratio
        PVector result = PVector.mult(vert1, 1 - ratio).add(PVector.mult(vert2, ratio));
        float dist = result.magSq();
        for (int i = 1; i < num_vert; ++i) {
            vert2.set(vert1);
            vert1.set(PVector.sub(vertices.get(i), point));
            v21.set(vert1).sub(vert2);
            ratio = Math.max(0, Math.min(1, vert1.dot(v21) / v21.magSq()));
            PVector res = PVector.mult(vert1, 1 - ratio).add(PVector.mult(vert2, ratio));
            if (res.magSq() < result.magSq()) {
                result.set(res);
            }
        }
        return result;
    }

    public void translate(PVector trans) {
        for (PVector vert : vertices) {
            vert.add(trans);
        }
    }

    public void scale(float s) {
        for (PVector vert : vertices) {
            vert.mult(s);
        }
    }

    public void draw() {
        push();
        beginShape();
        for (PVector vert : vertices) {
            vertex(vert.x, vert.y);
            circle(vert.x, vert.y, 30);
        }
        endShape(CLOSE);
        pop();
    }
}
