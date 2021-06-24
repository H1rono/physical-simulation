import java.util.List;
import java.util.ArrayList;
import java.util.ListIterator;

class World {
    private List<WorldElement> elements;
    private List<Pair> pairs;
    public PVector gravity;

    public World(PVector gravity) {
        elements = new ArrayList<WorldElement>();
        pairs = new ArrayList<Pair>();
        this.gravity = gravity;
    }

    public void add_element(WorldElement elem) {
        elements.add(elem);
    }

    private void update_velocity(float delta_time) {
        PVector delta_vel = PVector.mult(gravity, delta_time);
        for (WorldElement elem : elements) {
            elem.add_velocity(delta_vel);
        }
    }

    private List<Pair> find_pairs() {
        List<Pair> result = new ArrayList<Pair>();
        int elem_num = elements.size();
        for (int i = 0; i < elem_num - 1; ++i)
        for (int j = i + 1; j < elem_num; ++j) {
            WorldElement elem_i = elements.get(i), elem_j = elements.get(j);
            if (!elem_i.aabb_collide(elem_j)) { continue; }
            result.add(make_pair(elem_i, elem_j, i, j));
        }
        return result;
    }

    private boolean contain_pair(Pair pair) {
        // めぐる式二分探索
        // https://qiita.com/drken/items/97e37dd6143e33a64c8c
        int left = -1, right = pairs.size();
        if (right == 0) { return false; }
        while (right - left > 1) {
            int mid = (right + left) >> 1;
            Pair mpair = pairs.get(mid);
            if (pair.idA < mpair.idA || (pair.idA == mpair.idA && pair.idB <= mpair.idB)) {
                right = mid;
            } else {
                left = mid;
            }
        }
        if (right == pairs.size()) { return false; }
        Pair p = pairs.get(right);
        return pair.idA == p.idA && pair.idB == p.idB;
    }

    public void merge_pairs(List<Pair> new_pairs) {
        // https://qiita.com/yoshi389111/items/c24f8beefb7b96cad921
        ListIterator<Pair> pair_it = new_pairs.listIterator();
        while (pair_it.hasNext()) {
            Pair npair = pair_it.next();
            if (npair.type == PairType.not_collide) {
                pair_it.remove();
                continue;
            }
            if (contain_pair(npair)) {
                npair.type = PairType.pair_keep;
            }
        }
        pairs.clear();
        pairs = new_pairs;
    }

    private List<SolverBody> make_solver_bodies() {
        List<SolverBody> result = new ArrayList<SolverBody>();
        for (WorldElement elem : elements) {
            result.add(make_solver_body(elem));
        }
        return result;
    }

    private List<Constraint> make_constraints(float delta_time) {
        List<Constraint> result = new ArrayList<Constraint>();
        for (Pair pair : pairs) {
            result.add(pair2constraint(pair, delta_time));
        }
        return result;
    }

    public void process_constraints(List<Constraint> constraints) {
        List<SolverBody> solver_bodies = make_solver_bodies();
        // インパルス法を反復
        for (int it_num = 0; it_num < 10; it_num++) {
            int pair_num = pairs.size();
            for (int pair_i = 0; pair_i < pair_num; pair_i++) {
                Pair pair = pairs.get(pair_i);
                Constraint constraint = constraints.get(pair_i);
                SolverBody sbA = solver_bodies.get(pair.idA), sbB = solver_bodies.get(pair.idB);
                constraint.eval(sbA, sbB);
            }
        }
        int body_num = elements.size();
        for (int i = 0; i < body_num; i++) {
            WorldElement elem = elements.get(i);
            SolverBody solver_body = solver_bodies.get(i);
            println(solver_body.delta_velocity);
            elem.add_velocity(solver_body.delta_velocity);
        }
    }

    public void update(float delta_time) {
        update_velocity(delta_time);
        List<Pair> new_pairs = find_pairs();
        merge_pairs(new_pairs);
        List<Constraint> constraints = make_constraints(delta_time);
        process_constraints(constraints);
        for (WorldElement elem : elements) {
            elem.update_center(delta_time);
        }
    }

    public void draw() {
        for (WorldElement elem : elements) {
            elem.draw();
        }
    }
}