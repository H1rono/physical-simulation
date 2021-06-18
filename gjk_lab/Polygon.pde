// 多角形
// 凹みを許し、できるだけ辺同士が交差しないように頂点を管理する
class Polygon {
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
        PVector unit1 = PVector.sub(vertices.get(0), vert).normalize(),
                unit2 = PVector.sub(vertices.get(num_vert - 1), vert).normalize();
        float cos_min = unit1.dot(unit2);
        int insert_index = num_vert;
        for (int i = 1; i < num_vert; ++i) {
            unit2 = unit1;
            unit1 = PVector.sub(vertices.get(i), vert).normalize();
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
        PVector vert1 = PVector.sub(vertices.get(0), point),
                vert2 = PVector.sub(vertices.get(num_vert - 1), point);
        PVector v21 = PVector.sub(vert1, vert2); // vert2 -> vert1
        float ratio = vert1.dot(v21) / v21.magSq();
        // result = vert1 + ratio * (vert2 - vert1)    <---- if 0 <= ratio <= 1
        // result = vert1                              <---- if ratio < 0
        // result = vert2                              <---- if 1 < ratio
        PVector result = PVector.add(vert1, v21.mult(max(min(ratio, 1), 0) - 1));
        float dist = result.magSq();
        for (int i = 1; i < num_vert; ++i) {
            vert2.set(vert1);
            vert1.set(vertices.get(i)).sub(point);
            v21.set(vert1).sub(vert2);
            ratio = vert1.dot(v21) / v21.magSq();
            PVector res = PVector.add(vert1, v21.mult(max(min(ratio, 1), 0) - 1));
            float d = res.magSq();
            if (d < dist) {
                dist = d;
                result.set(res);
            }
        }
        return result.mult(-1);
    }

    public void draw() {
        push();
        beginShape();
        for (PVector vert : vertices) {
            vertex(vert.x, vert.y);
        }
        endShape(CLOSE);
        pop();
    }
}