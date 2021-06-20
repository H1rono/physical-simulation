import java.util.List;
import java.util.ArrayList;

class World implements Drawable {
    private List<WorldElement> elements;
    private List<RigidRelation> relations;
    private PVector gravity;

    public World(PVector gravity) {
        elements = new ArrayList<WorldElement>();
        relations = new ArrayList<RigidRelation>();
        this.gravity = new PVector();
        this.gravity.set(gravity);
    }

    public void add_element(WorldElement element) {
        elements.add(element);
    }

    public void check_collision() {
        int length = elements.size();
        for (int i = 0; i < length - 1; ++i)
        for (int j = i + 1; j < length; ++j) {
            WorldElement elem_i = elements.get(i), elem_j = elements.get(j);
            if (!elem_i.is_movable() && !elem_j.is_movable()) { continue; }
            if (!elem_i.aabb_collide(elem_j)) { continue; }
            RigidRelation relation = make_relation_gjk(elem_i, elem_j);
            if (!relation.collision) { continue; }
            relations.add(relation);
        }
    }

    private void solve_relation(RigidRelation relation) {
        // col: 衝突面と垂直方向
        // par: 衝突面と平行方向
        boolean movable = relation.rigid1.is_movable() && relation.rigid2.is_movable();
        float v1_col, v1_par, v2_col, v2_par;
        PVector col_n = relation.contact_normal.copy().normalize();
        PVector par_n = new PVector(col_n.y, -col_n.x);
        PVector v1 = relation.rigid1.get_velocity(), v2 = relation.rigid2.get_velocity();
        v1_col = v1.dot(col_n); v1_par = v1.dot(par_n);
        v2_col = v2.dot(col_n); v2_par = v2.dot(par_n);
        float mass1 = relation.rigid1.get_mass(), mass2 = relation.rigid2.get_mass();
        float impulse_col = ( // 運動量保存の力積
            (movable ? mass1 * mass2 / (mass1 + mass2) : 1)
            * (1 + 1/* 反発係数 */) * (-v1_col + v2_col)
        );
        float impulse_par = 0;
        float force_col = ( // ペナルティ法の力
            col_n.dot(relation.contact_normal)
        );
        float force_par = (
            (v1_par == v2_par) // true => 静止摩擦力, false => 動摩擦力
            ? 0
            : 0 // (v2_par - v1_par) / abs(v2_par - v1_par)
        );
        PVector impulse = PVector.mult(col_n, impulse_col).add(PVector.mult(par_n, impulse_par));
        relation.rigid1.add_impulse(impulse);
        impulse.mult(-1);
        relation.rigid2.add_impulse(impulse);
        PVector force = PVector.mult(col_n, force_col).add(PVector.mult(par_n, force_par));
        relation.rigid1.add_impulse(force);
        force.mult(-1);
        relation.rigid2.add_impulse(force);
    }

    public void solve_relations() {
        for (RigidRelation rel : relations) {
            solve_relation(rel);
        }
        relations.clear();
    }

    public void update(float delta_time) {
        for (WorldElement elem : elements) {
            elem.reset_force(PVector.mult(gravity, elem.get_mass()));
            elem.reset_impulse(new PVector(0, 0));
        }
        check_collision();
        solve_relations();
        for (WorldElement elem : elements) {
            elem.update(delta_time);
        }
    }

    public void draw() {
        for (Drawable elem : elements) {
            elem.draw();
        }
    }
}