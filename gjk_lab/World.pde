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

    private PVector solve_relation_impulse(RigidRelation relation) {
        boolean movable1 = relation.rigid1.is_movable(), movable2 = relation.rigid2.is_movable();
        PVector col_n = relation.contact_normal.copy().normalize();
        PVector par_n = new PVector(col_n.y, -col_n.x);
        PVector v1 = relation.rigid1.get_velocity(), v2 = relation.rigid2.get_velocity();
        float v1_col, v2_col;
        v1_col = v1.dot(col_n);
        v2_col = v2.dot(col_n);
        float mass1 = relation.rigid1.get_mass(), mass2 = relation.rigid2.get_mass();
        float impulse_col = ( // 運動量保存の力積
            (movable1 && movable2 ? mass1 * mass2 / (mass1 + mass2)
                : movable1 ? mass1
                :/*movable2*/mass2)
            * (1 + 1/* 反発係数 */) * (-v1_col + v2_col)
        );
        float impulse_par = 0;
        return PVector.mult(col_n, impulse_col).add(PVector.mult(par_n, impulse_par));
    }

    private PVector solve_relation_force(RigidRelation relation) {
        PVector col_n = relation.contact_normal.copy().normalize();
        PVector par_n = new PVector(col_n.y, -col_n.x);
        PVector f1 = relation.rigid1.get_force(), f2 = relation.rigid2.get_force();
        float f1_col, f1_par, f2_col, f2_par;
        float v1_par = relation.rigid1.get_velocity().dot(par_n);
        float v2_par = relation.rigid2.get_velocity().dot(par_n);
        f1_col = f1.dot(col_n); f1_par = f1.dot(par_n);
        f2_col = f2.dot(col_n); f2_par = f2.dot(par_n);
        float rel_fcol = f1_col - f2_col, rel_fpar = f1_par - f2_par;
        float force_col = ( // ペナルティ法の力 + 作用/反作用
            //- relation.contact_normal.mag()
            - rel_fcol
        );
        float force_par = 0;
        if (rel_fcol > 0) {
            if (v1_par == v2_par) {
                // 静止摩擦力
                if (f1_par != f2_par) {
                    float fpar_mag = Math.min(Math.abs(rel_fpar), rel_fcol * 1/* 静止摩擦係数 */);
                    float fpar_sign = -rel_fpar / Math.abs(rel_fpar);
                    force_par = fpar_mag * fpar_sign;
                }
            } else {
                // 動摩擦力
                float rel_vpar = v1_par - v2_par;
                float fpar_mag = Math.abs(rel_fcol) * 0.5f/* 動摩擦係数 */;
                float fpar_sign = -rel_vpar / Math.abs(rel_vpar);
                force_par = fpar_mag * fpar_sign;
            }
        }
        return PVector.mult(col_n, force_col).add(PVector.mult(par_n, force_par));
    }

    private void solve_relation(RigidRelation relation) {
        // col: 衝突面と垂直方向, par: 衝突面と平行方向
        PVector impulse = solve_relation_impulse(relation);
        relation.rigid1.add_impulse(impulse);
        impulse.mult(-1);
        relation.rigid2.add_impulse(impulse);

        PVector force = solve_relation_force(relation);
        relation.rigid1.add_force(force);
        force.mult(-1);
        relation.rigid2.add_force(force);
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