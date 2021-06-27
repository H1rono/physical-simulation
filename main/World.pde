class World implements Drawable {
    //! 計算対象となる剛体のリスト
    private List<Rigid> rigids;
    //! 衝突しているペアのリスト
    private List<Pair> pairs;
    //! 重力加速度
    public PVector gravity;

    /**
     * @brief 新しいWorldインスタンスを作成
     * @param gravity 重力加速度
     */
    public World(PVector gravity) {
        rigids = new ArrayList<Rigid>();
        pairs = new ArrayList<Pair>();
        this.gravity = gravity;
    }

    /**
     * @brief 演算対象の剛体を追加
     * @param rigid 追加する剛体
     */
    public void add_element(Rigid rigid) {
        rigid.set_id(rigids.size());
        rigids.add(rigid);
    }

    /**
     * @brief 剛体に重力を加える
     * @param delta_time 微小時間
     */
    private void apply_external_force(float delta_time) {
        PVector delta_velocity = PVector.mult(gravity, delta_time);
        for (Rigid rigid : rigids) {
            rigid.add_velocity(delta_velocity);
        }
    }

    private boolean contain_pair(Pair pair) {
        // めぐる式二分探索
        // https://qiita.com/drken/items/97e37dd6143e33a64c8c
        // pairsは(rigid_aのid, rigid_bのid)で辞書式にソートされているので、それを利用する
        int ng_index = -1, ok_index = pairs.size();
        int idA = pair.rigid_a.get_id(), id_a = pair.rigid_b.get_id();
        if (ok_index == 0) {
            return false;
        }
        while (ok_index - ng_index > 1) {
            int mid = (ok_index + ng_index) >> 1;
            Pair mid_pair = pairs.get(mid);
            int mid_id_a = mid_pair.rigid_a.get_id(), mid_id_b = mid_pair.rigid_b.get_id();
            if (mid_id_a == id_a && mid_id_a == id_a) {
                return true;
            }
            if (mid_id_a < id_a || (mid_id_a == id_a && mid_id_a < id_a)) {
                ok_index = mid;
            } else {
                ng_index = mid;
            }
        }
        return false;
    }

    //! 剛体同士の衝突を検出する
    private void detect_collision() {
        int rigid_num = rigids.size();
        // 前フレームのpairsと比較するためのリスト
        List<Pair> new_pairs = new ArrayList<Pair>();
        // 剛体2つの組み合わせ全てで衝突を検査
        for (int i = 0; i < rigid_num - 1; i++)
        for (int j = i + 1; j < rigid_num; j++) {
            Rigid rigid_i = rigids.get(i), rigid_j = rigids.get(j);
            if (!aabb_collide(rigid_i, rigid_j)) {
                continue;
            }
            Pair pair = make_pair(rigid_i, rigid_j);
            if (pair.type == PairType.not_collide) {
                continue;
            }
            if (contain_pair(pair)) {
                pair.type = PairType.collide_keep;
            }
            new_pairs.add(pair);
        }
        pairs.clear();
        pairs = new_pairs;
    }

    /**
     * @brief 衝突ペアから拘束を算出する
     * @param pair 算出元の衝突ペア
     * @param delta_time 微小時間
     */
    private Constraint[] pair2constraint(Pair pair, float delta_time) {
        PVector velocity_a = pair.rigid_a.get_velocity();
        PVector velocity_b = pair.rigid_b.get_velocity();
        PVector relative_vel = PVector.sub(velocity_a, velocity_b);

        // 反発は新しいペアだけで起こる
        float restitution = pair.type == PairType.collide_new ? (pair.rigid_a.restitution_rate() + pair.rigid_b.restitution_rate()) * 0.5 : 0;
        PVector axis = new PVector(pair.contact_normal.x, pair.contact_normal.y).normalize();
        // 拘束式の分母
        float jac_diag_inv = 1 / (pair.rigid_a.get_mass_inv() + pair.rigid_b.get_mass_inv());
        // 速度補正
        float rhs = -(1 + restitution) * axis.dot(relative_vel);
        // 位置補正
        rhs -= pair.contact_normal.mag() / delta_time;
        rhs *= jac_diag_inv;
        Constraint constraint_rest = new Constraint(axis, rhs, jac_diag_inv);

        float friction = sqrt(pair.rigid_a.friction_rate() * pair.rigid_b.friction_rate());
        axis = new PVector(axis.y, -axis.x);
        rhs = -(1 + restitution) * axis.dot(relative_vel) - pair.contact_normal.mag() / delta_time;
        rhs *= jac_diag_inv;
        Constraint constraint_fric = new Constraint(axis, rhs, jac_diag_inv, -friction, friction);

        return new Constraint[] {constraint_rest, constraint_fric};
    }

    //! 拘束力を計算する
    private void solve_constraints(float delta_time) {
        List<SolverBody> solver_bodies = new ArrayList<SolverBody>();
        for (Rigid rigid : rigids) {
            solver_bodies.add(make_solver_body(rigid));
        }
        List<Constraint[]> constraints = new ArrayList<Constraint[]>();
        for (Pair pair : pairs) {
            constraints.add(pair2constraint(pair, delta_time));
        }
        for (int _ = 0; _ < 100; _++) {
            for (int i = 0; i < constraints.size(); i++) {
                Pair pair = pairs.get(i);
                SolverBody solver_body_a = solver_bodies.get(pair.rigid_a.get_id());
                SolverBody solver_body_b = solver_bodies.get(pair.rigid_b.get_id());
                Constraint[] cns = constraints.get(i);
                Constraint constraint_rest = cns[0], constraint_fric = cns[1];
                constraint_rest.eval(solver_body_a, solver_body_b);
                constraint_fric.eval(solver_body_a, solver_body_b);
            }
        }
        for (int i = 0; i < rigids.size(); i++) {
            Rigid rigid = rigids.get(i);
            SolverBody solver_body = solver_bodies.get(i);
            rigid.add_velocity(solver_body.delta_velocity);
        }
    }

    //! 剛体の位置を更新する
    private void move(float delta_time) {
        for (Rigid rigid : rigids) {
            rigid.move(delta_time);
        }
    }

    /**
     * @brief 1フレームの計算
     * @param delta_time 微小時間
     */
    public void update(float delta_time) {
        apply_external_force(delta_time);
        detect_collision();
        solve_constraints(delta_time);
        move(delta_time);
    }

    @Override
    public void draw(PApplet applet) {
        for (Rigid rigid : rigids) {
            rigid.draw(applet);
        }
    }
}