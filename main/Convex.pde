//! 凸包を表示する型
interface Convex {
    //! サポート写像
    public PVector support(PVector point);
}

/**
 * @brief 軸並行バウンディングボックスが衝突しているかを判定する
 * @param convex_a 判定対象の凸包1
 * @param convex_b 判定対象の凸包2
 * @return true AABBが衝突している
 * @return false AABBが衝突していない
 */
boolean aabb_collide(Convex convex_a, Convex convex_b) {
    PVector axis_vec = new PVector(1, 0);
    // 凸包上の点で、x座標の最大値
    float max_x_a = convex_a.support(axis_vec).x, max_x_b = convex_b.support(axis_vec).x;
    // 凸包上の点で、x座標の最小値
    axis_vec.set(-1, 0);
    float min_x_a = convex_a.support(axis_vec).x, min_x_b = convex_b.support(axis_vec).x;
    // 凸包上の点で、y座標の最大値
    axis_vec.set(0, 1);
    float max_y_a = convex_a.support(axis_vec).y, max_y_b = convex_b.support(axis_vec).y;
    // 凸包上の点で、y座標の最小値
    axis_vec.set(0, -1);
    float min_y_a = convex_a.support(axis_vec).y, min_y_b = convex_b.support(axis_vec).y;
    boolean x_col = !(max_x_a <= min_x_b || max_x_b <= min_x_a),
            y_col = !(max_y_a <= min_y_b || max_y_b <= min_y_a);
    return x_col && y_col;
}