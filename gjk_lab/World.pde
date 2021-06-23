import java.util.List;
import java.util.ArrayList;

class World implements Drawable {
    private List<WorldElement> elements;
    private List<RigidRelation> relations;
    private PVector gravity;

    public World(PVector _gravity) {
        elements = new ArrayList<WorldElement>();
        relations = new ArrayList<RigidRelation>();
        gravity = new PVector().set(_gravity);
    }

    public void add_element(WorldElement element) {
        elements.add(element);
    }

    public void stack_relations() {
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

    private void solve_relations(RigidRelation relation){
        // col: 衝突面と垂直方向
        // par: 衝突面と平行方向
        boolean movable = relation.rigid1.is_movable() && relation.rigid2.is_movable();
        if(!relation.rigid1.is_movable() && !relation.rigid2.is_movable()){ return; }
        if(relation.contact_normal.mag() == 0){ return; }
        float v1_col, v1_par, v2_col, v2_par;
        PVector col_n = relation.contact_normal.copy().normalize();
        PVector par_n = new PVector(col_n.y, -col_n.x);
        PVector v1 = relation.rigid1.get_velocity(), v2 = relation.rigid2.get_velocity();
        v1_col = v1.dot(col_n); v1_par = v1.dot(par_n);
        v2_col = v2.dot(col_n); v2_par = v2.dot(par_n);
        float mass1 = relation.rigid1.get_mass(), mass2 = relation.rigid2.get_mass();

        float impulse_col = ( // 運動量保存の力積
            (movable ? mass1 * mass2 / (mass1 + mass2) : min(mass1 , mass2))
            * (1 + 0.7/* 反発係数 */) * (-v1_col + v2_col)
        );
        float impulse_par = 0;
        float force_col = 0;
        float force_par = (
            (v1_par == v2_par) // true => 静止摩擦力, false => 動摩擦力
            ? 0
            : 0 // (v2_par - v1_par) / abs(v2_par - v1_par)
        );
        //println(counter++);

        //println(relation.rigid1,relation.rigid1.get_velocity());
        //println(relation.rigid2,relation.rigid2.get_velocity());
        //println("=>");
        PVector impulse = PVector.mult(col_n, impulse_col).add(PVector.mult(par_n, impulse_par));
        //println(impulse);
        relation.rigid1.add_impulse(impulse);
        impulse.mult(-1);
        relation.rigid2.add_impulse(impulse);
        //println(relation.rigid1,relation.rigid1.get_velocity());
        //println(relation.rigid2,relation.rigid2.get_velocity());
        //println();
        
        PVector force = PVector.mult(col_n, force_col).add(PVector.mult(par_n, force_par));
        relation.rigid1.add_force(force);
        force.mult(-1);
        relation.rigid2.add_force(force);
    }

    // めり込み解消
    // めり込み解消ベクトルが0ベクトルの時trueを返す
    // または両方のobjectがmovableでないときtrue
    private boolean solve_biting(RigidRelation relation) {
        boolean movable = relation.rigid1.is_movable() && relation.rigid2.is_movable();
        if(!relation.rigid1.is_movable() && !relation.rigid2.is_movable()){ return true; }
        if(relation.contact_normal.mag() ==0){ return true; }
        if(Float.isNaN(relation.contact_normal.x)){ println("can be error"); return true; }
        float v1_col, v2_col;
        PVector col_n = relation.contact_normal.copy().normalize();
        PVector grav_col_n = gravity.copy().normalize();
        PVector grav_par_n = new PVector(grav_col_n.y, -grav_col_n.x);
        PVector v1 = relation.rigid1.get_velocity(), v2 = relation.rigid2.get_velocity();
        v1_col = v1.dot(col_n);v2_col = v2.dot(col_n);
        PVector x1=new PVector(),x2=new PVector();
        if(v2_col==v1_col){
            if(movable){
                x1.set(relation.contact_normal).mult(-0.5);
                x2.set(relation.contact_normal).mult(0.5);
            }else{
                x1.set(relation.contact_normal).mult(-1);
                x2.set(relation.contact_normal).mult(1);
            }
        }else{
            x1.set(relation.contact_normal).mult(v1_col/(v2_col-v1_col));
            x2.set(relation.contact_normal).mult(v2_col/(v2_col-v1_col));
        }
        relation.rigid1.add_center(x1);
        relation.rigid2.add_center(x2);
        println(counter++);
        println(x1,x2);
        float vel1_col = v1.dot(grav_col_n), vel1_par = v1.dot(grav_par_n);
        float vel2_col = v2.dot(grav_col_n), vel2_par = v2.dot(grav_par_n);
        vel1_col=sq(vel1_col) + 2 * PVector.dot(gravity,x1);
        vel2_col=sq(vel2_col) + 2 * PVector.dot(gravity,x2);
        vel1_col=(vel1_col > 0 ? sqrt(vel1_col) : 0);
        vel2_col=(vel2_col > 0 ? sqrt(vel2_col) : 0);
        vel1_col=(v1.dot(grav_col_n) > 0 ? vel1_col : -vel1_col);
        vel2_col=(v2.dot(grav_col_n) > 0 ? vel2_col : -vel2_col);
        PVector _vel1 = PVector.mult(grav_col_n, vel1_col).add(PVector.mult(grav_par_n, vel1_par));
        PVector _vel2 = PVector.mult(grav_col_n, vel2_col).add(PVector.mult(grav_par_n, vel2_par));
        
        println(relation.rigid1,relation.rigid1.get_velocity());
        println(relation.rigid2,relation.rigid2.get_velocity());
        println("=>");
        relation.rigid1.set_velocity(_vel1);
        relation.rigid2.set_velocity(_vel2);
        println(relation.rigid1,relation.rigid1.get_velocity());
        println(relation.rigid2,relation.rigid2.get_velocity());
        println();
        return false;
    }
    int counter = 0;
    // すべてめり込み解消ベクトルが0ベクトルの時trueを返す
    public boolean solve_bitings() {
        boolean ret = true;
        for (RigidRelation rel : relations) {
            if(!solve_biting(rel)){ret=false; }
        }
        return ret;
    }

    public void update(float delta_time) {
        for (WorldElement elem : elements) {
            elem.set_force(PVector.mult(gravity, elem.get_mass()));
            elem.reset_impulse();
        }
        for (WorldElement elem : elements) {
            elem.update(delta_time);
        }
        stack_relations();
        for (RigidRelation rel : relations) {
            solve_relations(rel);
        }
        for (WorldElement elem : elements) {
            elem.apply_impulse();
            elem.reset_impulse();
        }
        relations.clear();
        // 反復部分を回数制限付きで実行
        for(int i = 0; i < 5; i++){
            stack_relations();
            if (relations.isEmpty()) { break; }
            if (solve_bitings()) { break; }
            for (WorldElement elem : elements) {
                elem.apply_impulse();
                elem.reset_impulse();
            }
            relations.clear();
        }
    }

    public void draw() {
        for (Drawable elem : elements) {
            elem.draw();
        }
    }
}
